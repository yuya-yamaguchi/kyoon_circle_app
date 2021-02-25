class Api::MypageController < ApplicationController
  before_action :auth_check

  def show
    user_instruments = @current_user.set_instruments
    user = @current_user.set_follow_count
    render status: 200, json: { user: user, user_instruments: user_instruments }
  end

  def studio_reserves
    future_reserves = @current_user.studio_reserves.after_today_desc
    history_reserves = @current_user.studio_reserves.bofore_today_desc
    render status: 200, json: { future_reserves: future_reserves, history_reserves: history_reserves }
  end

  def events
    out_future_params  = []
    out_history_params = []
    future_events = @current_user.events.after_today.order_date_desc
    future_events.each do |future_event|
      out_future_params << future_event.set_index_params
    end
    history_events = @current_user.events.before_today.order_date_desc
    history_events.each do |history_event|
      out_history_params << history_event.set_index_params
    end
    render status: 200, json: { future_events: out_future_params, history_events: out_history_params }
  end
end
