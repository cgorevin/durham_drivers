class ReliefMessagesController < ApplicationController
  def show
    @relief_message = ReliefMessage.find params[:id]
  end
end
