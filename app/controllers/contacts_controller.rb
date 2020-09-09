require 'csv'

class ContactsController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :show, :edit]

  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html
      format.csv do
        @contacts = @contacts.includes(:offenses)
        send_data @contacts.to_csv
      end
    end
  end

  def queued
    @queued = Contact.queued.order(queue_date: :asc)

    respond_to do |format|
      format.html
      format.csv do
        @queued = @queued.includes(:offenses)
        send_data @queued.to_csv
      end
    end
  end

  def unqueued
    @unqueued = Contact.unqueued.order(email: :asc)

    respond_to do |format|
      format.html
      format.csv do
        @unqueued = @unqueued.includes(:offenses)
        send_data @unqueued.to_csv
      end
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
      relief_message = contact.add_offenses ids

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

    flash.notice = <<~HTML
      View your Relief Letter here:
      <a id="popup" href="#{token_path(relief_message.token, format: :pdf)}" target="_blank">See Relief Letter</a>
      <script>
        var href = $('#popup')[0].href;
        window.open(href, '_blank');
      </script>
    HTML
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
