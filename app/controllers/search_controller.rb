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

    # @exact_matches = Offense.exact_search(@first, @middle, @last, @dob).to_a
    @offenses = Offense.fuzzy_search(@first, @middle, @last, @dob).to_a
    # @similar_matches = @similar_matches - @exact_matches

    # NOTE: redirect if no matches
    # redirect to results page with 0 offenses
    redirect_to results_path if @offenses.empty?
  end

  def results
    # collect all the ids
    @ids = params[:ids]&.join(' ')&.split

    # load offenses based on ids
    @offenses = Offense.where id: @ids
    @offense = @offenses.first

    # based on all the offenses gathered, show some type of message
  end

  def sign_up
  end

  def next_steps
  end
end
