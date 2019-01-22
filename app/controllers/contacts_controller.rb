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
    contact = Contact.create contact_params

    if contact.persisted?
      ids = params[:ids].split
      contact.offense_ids = ids
    end

    redirect_to sign_up_path, notice: 'nice'
  end

  private

  def contact_params
    params.require(:contact).permit(:method, :info)
  end
end
