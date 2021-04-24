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
    read_messages = @messageroom.messages.where.not(user_id: @current_user.id).where(read_flg: false)
    read_messages.update(read_flg: true)
    messages = @messageroom.messages
    dm_user = User.find(params[:user_id])
    render status: 200, json: { messageroom: @messageroom, messages: messages, dm_user: dm_user }
  end

  def create
    @messageroom = Messageroom.find(params[:messageroom][:id])
    message = Message.new(message_params)
    if message.save
      render status: 201, json: { message: message }
    else
      render status: 400
    end
  end

  private
  def message_params
    params.require(:message).permit(:text).merge(messageroom_id: @messageroom.id, user_id: @current_user.id)
  end
end
