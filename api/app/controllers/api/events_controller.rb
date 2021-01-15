class Api::EventsController < ApplicationController
  include Pagy::Backend
  include ActionController::HttpAuthentication::Token::ControllerMethods
  
  before_action :user_check, only: [:entry, :entry_cancel]

  def index
    out_params = []
    pagy, events = pagy(Event.all.order('start_datetime DESC'), items: 5)
    events.each do |event|
      out_params << event.set_out_params
    end
    render json: { events: out_params, pagy: pagy_metadata(pagy) }
  end

  def show
    entry_flg = false
    event = Event.find(params[:id])
    if params[:user_id].to_i > 0
      cnt = EventEntry.where(event_id: params[:id])
                      .where(user_id: params[:user_id])
                      .count
      entry_flg = true if cnt > 0
    end
    entry_cnt = EventEntry.where(event_id: params[:id]).count
    out_params = event.set_out_params
    render json: { event: out_params,
                   entry_flg: entry_flg,
                   entry_cnt: entry_cnt }
  end

  def edit
    event = Event.find(params[:id])
    out_params = event.set_edit_params
    render json: out_params
  end

  def update
    event_params = require_event_params
    event = Event.find(params[:id])
    if event.update(set_event_params(event_params))
      render status: 200
    else
      render status: 500, json: event.errors.full_messages
    end
  end
  
  def create
    event_params = require_event_params
    event = Event.new(set_event_params(event_params))
    if event.save
      # グループラインへのメッセージ送信
      if event.line_msg_push
        event.push_line
      end
      render status: 200, json: event
    else
      render status: 500, json: event.errors.full_messages
    end
  end

  def destroy
    if Event.destroy(params[:id])
      render status: 200
    end
  end

  def entry
    EventEntry.create(user_id: params[:user_id], event_id: params[:id])
    entry_cnt = EventEntry.where(event_id: params[:id]).count
    render json: entry_cnt
  end

  def entry_cancel
    event_entry = EventEntry.where(user_id: params[:user_id])
                            .where(event_id: params[:id])
    event_entry.destroy_all
    entry_cnt = EventEntry.where(event_id: params[:id]).count
    render json: entry_cnt
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
    # ユーザIDチェック
    if params[:user_id] == 0
      render status: 500, json:{ error_message: "会員登録（またはログイン）を行ってください" }
      return
    end
    # ユーザトークンチェック
    user = User.find_by(token: request.headers['Authorization'])
    if user == nil
      render status: 500, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" }
      return
    end
  end
end
