class ContactsController < ApplicationController
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
  end

  private

  def contact_params
    params.require(:contact).permit(:method, :info, :requestor_name)
  end
end
