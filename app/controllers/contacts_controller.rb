require 'csv'

class ContactsController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :show, :edit]

  def index
    @queued = Contact.where.not(queue_date: nil).order(queue_date: :asc)
    @unqueued = Contact.where(queue_date: nil).order(email: :asc)

    respond_to do |format|
      format.html
      format.csv { send_data Contact.queued_to_csv }
    end
  end

  def show
    @contact = Contact.find params[:id]
    @offenses = @contact.offenses
  end

  # Parameters: {
  #   "ids"=>"1 2 3",
  #   "contact"=>{
  #     "type"=>"email",
  #     "info"=>"nunez.a.cruz@gmail.com"
  #   },
  #   "commit"=>"Save"
  # }
  # POST '/contacts'
  def create
    ids = session[:ids]
    contact = Contact.find_or_create_by contact_params

    if contact.persisted?
      contact.add_offenses ids

      # raise error if any errors on model. rescue clause will handle the rest
      raise StandardError if contact.errors.any?

      session[:contact_id] = contact.id
    end

    offenses = Offense.where id: ids
    # we need to determine
    # 1. if person is approved
    # 2. if person is who they say they are
    approved = offenses.any?(&:approved?)
    not_requestor = contact.requestor_name.blank?
    if approved && not_requestor
      redirect_to sign_up_path
    else
      redirect_to next_steps_path
    end
  rescue StandardError
    phone = params[:contact][:phone]
    msg = t '.twilio_fail'
    redirect_to results_path(locale: params[:locale]), alert: msg % phone
  end

  def edit
    @contact = Contact.find params[:id]
  end

  # PATCH /contacts/123
  def update
    from_edit = request.referrer['edit']

    # if not from edit, clear session
    unless from_edit
      session.delete :contact_id # id should be present but possibly empty
    end
    # load contact and delete contact id
    contact = Contact.find params[:id] # params[:id] will be present
    contact.update contact_params

    if from_edit
      redirect_to contact
    else
      redirect_to next_steps_path
    end
  end

  private

  def contact_params
    params.require(:contact).permit(
      :relief_method, :advice_method,
      :email, :phone,
      :full_name, :requestor_name,
      :street, :city, :state, :zip,
      :queue_date
    )
  end
end
