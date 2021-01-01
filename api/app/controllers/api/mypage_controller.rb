class Api::MypageController < ApplicationController

  def show
    user = User.find(params[:id])
    render json: user
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render status: 200, json: user
    else
      render status: 500
    end
  end

  def studio_reserves
    user = User.find(params[:user_id])
    future_reserves = user.user_reserves
                      .where('date >= ?', Date.today)
                      .order('date DESC')
                      .order('start_time DESC')
    history_reserves = user.user_reserves
                       .where('date < ?', Date.today)
                       .order('date DESC')
                       .order('start_time DESC')
    render json: { future_reserves: future_reserves, history_reserves: history_reserves }
  end

  def events
    user = User.find(params[:user_id])
    future_events = user.events.where('start_datetime >= ? ', Date.today)
    history_events = user.events.where('start_datetime < ? ', Date.today)
    render json: { future_events: future_events, history_events: history_events }
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile)
  end
end
