class Api::Event::CommentsController < ApplicationController
  before_action :set_event
  before_action :user_check, only: [:create, :update, :destroy]

  def index
    event_comments = @event.event_comments.order('created_at DESC')
    out_params = []
    event_comments.each do |event_comment|
      out_params << event_comment.set_out_params
    end
    render status: 200, json: out_params
  end

  def create
    event_comment = @event.event_comments.new(event_comment_params)
    if event_comment.save
      out_params = event_comment.set_out_params
      render status: 201, json: out_params
    else
      render status: 400, json: event_comment.errors.full_messages
    end
  end

  def update
    event_comment = EventComment.find_by(id: params[:id])
    if event_comment.update(event_comment_params)
      render status: 204
    else
      render status: 400, json: event_comment.errors.full_messages
    end
  end

  def destroy
    event_comment = EventComment.find_by(id: params[:id])
    if event_comment.destroy
      render status: 204
    else
      render status: 400, json: event_comment.errors.full_messages
    end
  end

  private
  def event_comment_params
    params.require(:event_comment).permit(:text).merge(user_id: params[:user_id])
  end

  def set_event
    @event = Event.find_by(id: params[:event_id])
    render status: 404 if @event.nil?
  end

  def user_check
    @user = User.find_by(token: request.headers['Authorization'])
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if @user.nil?
  end
end
