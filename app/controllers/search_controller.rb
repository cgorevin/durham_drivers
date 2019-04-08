class SearchController < ApplicationController
  before_action :set_user_page

  def show
    @offense = Offense.new

    respond_to do |format|
      format.html
      format.rss { redirect_to root_path }
      format.env { redirect_to root_path }
    end
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
    if @offenses.empty?
      session[:ids] = nil
      redirect_to results_path
    end
  end

  # POST "/results"
  # POST "/en/results"
  # POST "/es/results"
  # GET "/results"
  # GET "/es/results"
  # GET "/es/results"
  def results
    # collect all the ids
    # place all ids in session variable and use for the rest of the pages
    if request.post?
      session[:ids] = params[:ids]&.join(' ')&.split
    end
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
      @contact = Contact.find contact_id
    else
      redirect_to root_path locale: params[:locale]
    end
  end

  def next_steps
    ids = session[:ids]

    # load offenses based on ids
    @offenses = Offense.where id: ids
  end


  private

  def set_user_page
    @user_page = true
  end
end
