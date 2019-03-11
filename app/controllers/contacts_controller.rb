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
    @offenses = Offense.where id: ids
    contact = Contact.find_or_create_by contact_params

    if contact.persisted?
      contact.add_offenses ids
    end

    redirect_to next_steps_path
  end

  private

  def contact_params
    params.require(:contact).permit(:method, :info, :requestor_name)
  end
end
