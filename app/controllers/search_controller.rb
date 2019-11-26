# controller that shows all of non-admin pages
class SearchController < ApplicationController
  before_action :set_user_page

  def show
    # sets cache to public 2 minutes
    expires_in 30.minutes, public: true
    @offense = Offense.new

    respond_to do |format|
      format.html
      format.any { redirect_to root_path }
    end
  end

  # POST "/confirm"
  # POST "/en/confirm"
  # POST "/es/confirm"
  def confirm
    set_data

    redirect_to(request.referer, alert: t('.required')) && return if invalid?

    # BUG: UNDEFINED METHOD TO_DATE OF FOR NIL. User agent: Firefox 54.0
    # CHRONIC#PARSE is returning nil
    # we already make sure first name, last name, and date of birth are required
    # but what happens when the date provided is unparsable by chronic?
    # the date of birth that caused this error was "date_of_birth": "12 23 1980"
    # what if we redirect if we get nil from chronic?
    set_query

    @offenses = Offense.fuzzy_search(@first, @middle, @last, @dob)
                       .where.not(status: 'pulled')
                       .order(first: :asc)
                       .to_a

    # NOTE: redirect if no matches found
    # redirect to results page with 0 offenses
    return unless @offenses.empty?

    session[:ids] = nil
    redirect_to results_path
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
    session[:ids] = params[:ids]&.join(' ')&.split if request.post?
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

  def invalid?
    [@first, @last, @dob].any?(&:blank?)
  end

  def set_data
    data = params[:offense]

    @first = data[:first_name]
    @middle = data[:middle_name]
    @last = data[:last_name]
    @dob = data[:date_of_birth]
  end

  def set_query
    # code against input like "12 23 1980", even after format restrictions
    # input like "12.23.1980" also is unparsable
    # @dob.gsub! ' ', '-' # works

    @query = [@first, @middle, @last].join(' ').squish
    @query << ", #{Chronic.parse(@dob).to_date.strftime '%b %-d, %Y'}"
  end

  def set_user_page
    @user_page = true
  end
end
