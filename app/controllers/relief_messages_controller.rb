class ReliefMessagesController < ApplicationController
  def show
    @relief_message = ReliefMessage.find params[:id]
    respond_to do |format|
      format.html
      format.pdf { render pdf: 'relief_message', layout: 'pdf.html' }
    end
  end
end
