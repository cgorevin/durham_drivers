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
                       .where.not(status: 'pulled')
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

  # where user can sign up for attorney help
  def sign_up
    contact_id = session[:contact_id]

    if contact_id.present?
      @contact = Contact.find session[:contact_id]
    else
      redirect_to root_path locale: params[:locale]
    end
  end

  def next_steps
    ids = session[:ids]

    # load offenses based on ids
    @offenses = Offense.where id: ids
  end

end
