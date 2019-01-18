class SearchController < ApplicationController
  def show
    @offense = Offense.new
  end

  def confirm
    data = params[:offense]

    @first = data[:first_name]
    @middle = data[:middle_name]
    @last = data[:last_name]
    @dob = data[:date_of_birth]

    @exact_matches = Offense.exact_search(@first, @middle, @last, @dob).to_a
    @similar_matches = Offense.similar_search(@first, @middle, @last, @dob).to_a
    @similar_matches = @similar_matches - @exact_matches

    # NOTE: redirect if no matches
    # if @all_matches.empty?
    #   redirect_to results_path([]) # redirect to results page with 0 offenses
    # end
  end

  def results
    # collect all the ids
    @ids = params[:ids].join(' ').split

    # load offenses based on ids
    @offenses = Offense.where id: @ids

    # based on all the offenses gathered, show some type of message
  end

  def sign_up
  end

  def next_steps
  end
end
