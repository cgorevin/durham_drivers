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
    @offenses = Offense.where id: params['ids'].split
    contact = Contact.find_or_create_by contact_params

    if contact.persisted?
      contact.add_offenses params[:ids].split
    end

    # NOTE: add some way for the sign up path to know which message to show
    # redirect_to sign_up_path
    render 'search/sign_up'
  end

  private

  def contact_params
    params.require(:contact).permit(:method, :info, :requestor_name)
  end
end
