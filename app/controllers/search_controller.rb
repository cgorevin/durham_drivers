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
  end

  def results
  end

  def sign_up
  end

  def next_steps
  end
end
