class ReliefMessagesController < ApplicationController
  def show
    if params[:id]
      @relief_message = ReliefMessage.find params[:id]
    elsif params[:token]
      @relief_message = ReliefMessage.find_by_token params[:token]
    end

    respond_to do |format|
      format.html
      format.pdf { render pdf: 'relief_message', layout: 'pdf.html' }
    end
  end
end
