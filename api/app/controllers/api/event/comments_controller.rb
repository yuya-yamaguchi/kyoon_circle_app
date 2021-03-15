class Api::Event::CommentsController < ApplicationController
  before_action :set_event
  before_action :set_event_comment, only: %i[update destroy]
  before_action :auth_check, only: %i[create update destroy]

  def index
    event_comments = @event.event_comments.recent
    out_params = event_comments.map { |event_comment| event_comment.set_out_params }
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
    if @event_comment.update(event_comment_params)
      render status: 204
    else
      render status: 400, json: @event_comment.errors.full_messages
    end
  end

  def destroy
    @event_comment = EventComment.find_by(id: params[:id])
    if @event_comment.destroy
      render status: 204
    else
      render status: 400, json: @event_comment.errors.full_messages
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

  def set_event_comment
    @event_comment = EventComment.find_by(id: params[:id])
    render status: 404 if @event_comment.nil?
  end
end
