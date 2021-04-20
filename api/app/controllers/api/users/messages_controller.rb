class Api::Users::MessagesController < ApplicationController
  before_action :auth_check, only: [:index, :create]


  def index
    messageroom_entry = MessageroomEntry.get_belong_room(@current_user.id ,params[:user_id])
    if messageroom_entry.empty?
      messageroom_params = {user_ids: [@current_user.id, params[:user_id]]}
      @messageroom = Messageroom.create!(messageroom_params)
    else
      @messageroom = Messageroom.find(messageroom_entry[0].messageroom_id)
    end
    render status: 200, json: { messageroom: @messageroom }
  end

  def create
    binding.pry
    @messageroom = Messageroom.find(params[:messageroom][:id])
    if Message.create(message_params)
      render status: 200
    else
      render status: 400
    end
  end

  private
  def message_params
    params.require(:message).permit(:text).merge(messageroom_id: @messageroom.id, user_id: @current_user.id)
  end
end
