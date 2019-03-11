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

    @offenses = Offense.fuzzy_search(@first, @middle, @last, @dob)
                       .order(first: :asc)
                       .to_a

    # NOTE: redirect if no matches
    # redirect to results page with 0 offenses
    redirect_to results_path if @offenses.empty?
  end

  def results
    # collect all the ids
    # place all ids in session variable and use for the rest of the pages
    session[:ids] = params[:ids]&.join(' ')&.split
    ids = session[:ids]

    # load offenses based on ids
    @offenses = Offense.where id: ids
    @offense = @offenses.first

    # based on all the offenses gathered, show some type of message
  end

  def sign_up
    ids = session[:ids]

    # load offenses based on ids
    @offenses = Offense.where id: ids
  end

  def next_steps
  end
end
