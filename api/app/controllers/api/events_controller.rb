class Api::EventsController < ApplicationController

  def index
    events = Event.all
    render json: events
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
    out_params = event.set_out_params
    render json: { event: out_params, entry_flg: entry_flg }
  end

  def create
    event_params = require_event_params
    Event.create!(set_event_params(event_params))
  end

  def entry
    EventEntry.create(user_id: params[:user_id], event_id: params[:id])
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
                  :event_type)
          .merge(user_id: params[:user_id])
  end

  def set_event_params(event_params)
    year  = event_params[:start_date][0, 4].to_i
    month = event_params[:start_date][5, 2].to_i
    day   = event_params[:start_date][8, 2].to_i
    start_datetime = DateTime.new(year, month, day, event_params[:start_hour].to_i, event_params[:start_min].to_i)
    end_datetime = DateTime.new(year, month, day, event_params[:end_hour].to_i, event_params[:end_min].to_i)
    return_params = {
      user_id: event_params[:user_id],
      title: event_params[:title],
      details: event_params[:details],
      place: event_params[:place],
      fee: event_params[:fee],
      max_entry: event_params[:max_entry],
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      event_type: event_params[:event_type]
    }
    return return_params
  end
end
