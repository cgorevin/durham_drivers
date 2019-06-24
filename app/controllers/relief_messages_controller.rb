class ReliefMessagesController < ApplicationController
  def show
    token = parmas[:token]

    if params[:id]
      @relief_message = ReliefMessage.find params[:id]
    elsif params[:token]
      @relief_message = ReliefMessage.find_by_token token
    end

    if @relief_message.nil? && request.format.pdf?
      redirect_to token_path token
    else
      respond_to do |format|
        format.html
        format.pdf { render pdf: 'relief_message', layout: 'pdf.html' }
      end
    end
  end
end
