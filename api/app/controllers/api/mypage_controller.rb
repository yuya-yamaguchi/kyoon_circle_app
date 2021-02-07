class Api::MypageController < ApplicationController
  before_action :auth_check

  def show
    user_instruments = @user.set_instruments
    render status: 200, json: { user: @user, user_instruments: user_instruments }
  end

  def update
    if @user.update(user_params)
      render status: 200, json: @user
    else
      render status: 422, json: @user.errors.full_messages
    end
  end

  def studio_reserves
    future_reserves = @user.studio_reserves.after_today_desc
    history_reserves = @user.studio_reserves.bofore_today_desc
    render status: 200, json: { future_reserves: future_reserves, history_reserves: history_reserves }
  end

  def events
    out_future_params  = []
    out_history_params = []
    future_events = @user.events.after_today.desc
    future_events.each do |future_event|
      out_future_params << future_event.set_index_params
    end
    history_events = @user.events.before_today.desc
    history_events.each do |history_event|
      out_history_params << history_event.set_index_params
    end
    render status: 200, json: { future_events: out_future_params, history_events: out_history_params }
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile, :avatar, { :instrument_ids => [] })
  end
end
