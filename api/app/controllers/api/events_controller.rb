class Api::EventsController < ApplicationController
  include Pagy::Backend
  
  before_action :auth_check, only: [:edit, :update, :create, :destroy, :entry, :entry_cancel]
  before_action :admin_check, only: [:edit, :update, :create, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :entry, :entry_cancel]

  def index
    search_events = Event.search(params[:event_category_id]).desc
    pagy, events = pagy(search_events, items: 5)
    out_params = []
    events.each do |event|
      out_params << event.set_index_params
    end
    render status: 200, json: { events: out_params, pagy: pagy_metadata(pagy) }
  end

  def show
    is_entry = false
    if params[:user_id].to_i > 0
      is_entry = @event.event_entries.where(user_id: params[:user_id]).present?
    end
    entry_cnt = @event.event_entries.count
    render status: 200,
           json: { event: @event, is_entry: is_entry, entry_cnt: entry_cnt }
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
      if event_params[:event_category_id] == 2
        EventSession.create(event_id: event.id)
      end
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
      render status: 404, json: event.errors.full_messages
    end
  end

  def entry
    event_entry = EventEntry.new(user_id: params[:user_id], event_id: params[:id])
    if event_entry.save
      entry_cnt = @event.event_entries.count
      render status: 200, json: entry_cnt
    else
      render status: 400, json:{ error_message: event_entry.errors.full_messages[0] }
    end
  end

  def entry_cancel
    event_entry = @event.event_entries.find_by(user_id: params[:user_id])
    if event_entry.destroy
      entry_cnt = @event.event_entries.count
      render status: 200, json: entry_cnt
    else
      render status: 400, json:{ error_message: event_entry.errors.full_messages[0] }
    end
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
                  :event_category_id,
                  :line_msg_push)
          .merge(user_id: params[:user_id])
  end

  def set_event_params(event_params)
    year  = event_params[:start_date][0, 4].to_i
    month = event_params[:start_date][5, 2].to_i
    day   = event_params[:start_date][8, 2].to_i
    if year > 0 && month > 0 && day > 0
      # DBの設定がUTCのため、9時間前を登録する
      start_datetime = DateTime.new(year, month, day, event_params[:start_hour].to_i, event_params[:start_min].to_i) - Rational(9, 24)
      if event_params[:end_hour] != "" && event_params[:end_min] != ""
        end_datetime = DateTime.new(year, month, day, event_params[:end_hour].to_i, event_params[:end_min].to_i) - Rational(9, 24)
      end
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
      event_category_id: event_params[:event_category_id],
      line_msg_push: event_params[:line_msg_push]
    }
    return return_params
  end

  def set_event
    @event = Event.find_by(id: params[:id])
    render status: 404 if @event.nil?
  end
end
