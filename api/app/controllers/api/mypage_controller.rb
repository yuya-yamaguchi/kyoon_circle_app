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
    future_events = @user.events.after_today.desc
    history_events = @user.events.before_today.desc
    render status: 200, json: { future_events: future_events, history_events: history_events }
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile, :avatar, { :instrument_ids => [] })
  end
end
