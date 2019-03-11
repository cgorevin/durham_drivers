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

    # NOTE: add some way for the sign up path to know which message to show
    redirect_to sign_up_path
    # render 'search/sign_up'
  end

  private

  def contact_params
    params.require(:contact).permit(:method, :info, :requestor_name)
  end
end
