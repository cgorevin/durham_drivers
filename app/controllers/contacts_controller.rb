class ContactsController < ApplicationController
  # Parameters: {
  #   "ids"=>"1 2 3",
  #   "contact"=>{
  #     "type"=>"email",
  #     "info"=>"nunez.a.cruz@gmail.com"
  #   },
  #   "commit"=>"Save"
  # }
  def create
    ids = params[:ids]
    contact = Contact.find_or_create_by contact_params

    if contact.persisted?
      contact.add_offenses ids
    end

    redirect_to sign_up_path, notice: 'Thank you'
  end

  private

  def contact_params
    params.require(:contact).permit(:method, :info, :requestor_name)
  end
end
