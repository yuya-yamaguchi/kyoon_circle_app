class Api::EventsController < ApplicationController
  include Pagy::Backend
  
  before_action :user_check, only: [:entry, :entry_cancel]
  before_action :set_event,  only: [:show, :edit, :update]

  def index
    pagy, events = pagy(Event.all.order('start_datetime DESC'), items: 5)
    render status: 200, json: { events: events, pagy: pagy_metadata(pagy) }
  end

  def show
    # ログイン時はユーザがそのイベントに参加しているか状態を確認
    entry_flg = false
    if params[:user_id].to_i > 0
      cnt = EventEntry.where(event_id: params[:id])
                      .where(user_id: params[:user_id])
                      .count
      entry_flg = true if cnt > 0
    end
    entry_cnt = EventEntry.where(event_id: params[:id]).count
    render status: 200,
           json: { event:     @event,
                   entry_flg: entry_flg,
                   entry_cnt: entry_cnt }
  end

  def edit
    out_params = @event.set_edit_params
    render status: 200, json: out_params
  end

  def update
    event_params = require_event_params
    if @event.update(set_event_params(event_params))
      render status: 204
    else
      render status: 422, json: @event.errors.full_messages
    end
  end
  
  def create
    event_params = require_event_params
    event = Event.new(set_event_params(event_params))
    if event.save
      # グループラインへのメッセージ送信
      event.push_line if event.line_msg_push
      render status: 201, json: event
    else
      render status: 422, json: event.errors.full_messages
    end
  end

  def destroy
    if @event.destroy
      render status: 204
    else
      render status: 404, json: news.errors.full_messages
    end
  end

  def entry
    EventEntry.create(user_id: params[:user_id], event_id: params[:id])
    entry_cnt = EventEntry.where(event_id: params[:id]).count
    render status: 200, json: entry_cnt
  end

  def entry_cancel
    event_entry = EventEntry.where(user_id: params[:user_id]).where(event_id: params[:id])
    event_entry.destroy_all
    entry_cnt = EventEntry.where(event_id: params[:id]).count
    render status: 200,json: entry_cnt
  end

  private
  def require_event_params
    params.require(:event)
          .permit(:title,
                  :details,
                  :start_date,
                  :start_hour,
                  :start_min,
                  :end_hour,
                  :end_min,
                  :place,
                  :fee,
                  :max_entry,
                  :event_type,
                  :line_msg_push)
          .merge(user_id: params[:user_id])
  end

  def set_event_params(event_params)
    year  = event_params[:start_date][0, 4].to_i
    month = event_params[:start_date][5, 2].to_i
    day   = event_params[:start_date][8, 2].to_i
    if year > 0 && month > 0 && day > 0
      start_datetime = DateTime.new(year, month, day, event_params[:start_hour].to_i, event_params[:start_min].to_i) - Rational(9, 24)
      end_datetime = DateTime.new(year, month, day, event_params[:end_hour].to_i, event_params[:end_min].to_i) - Rational(9, 24)
    end
    return_params = {
      user_id: event_params[:user_id],
      title: event_params[:title],
      details: event_params[:details],
      place: event_params[:place],
      fee: event_params[:fee],
      max_entry: event_params[:max_entry],
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      event_type: event_params[:event_type],
      line_msg_push: event_params[:line_msg_push]
    }
    return return_params
  end

  def user_check
    return render status: 401, json:{ error_message: "会員登録（またはログイン）を行ってください" } if params[:user_id] == 0
    user = User.find_by(token: request.headers['Authorization'])
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if user.nil?
  end

  def set_event
    @event = Event.find_by(id: params[:id])
    render status: 404 if @event.nil?
  end
end
