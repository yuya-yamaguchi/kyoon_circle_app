class Api::MypageController < ApplicationController
  before_action :set_user

  def show
    render status: 200, json: @user
  end

  def update
    if @user.update(user_params)
      render status: 200, json: @user
    else
      render status: 422, json: @user.errors.full_messages
    end
  end

  def studio_reserves
    now = Time.now.in_time_zone
    future_reserves = @user.studio_reserves
                      .where('date >= ?', now.to_date)
                      .order('date DESC')
                      .order('start_time DESC')
    history_reserves = @user.studio_reserves
                       .where('date < ?', now.to_date)
                       .order('date DESC')
                       .order('start_time DESC')
    render status: 200, json: { future_reserves: future_reserves, history_reserves: history_reserves }
  end

  def events
    now = Time.now.in_time_zone
    future_events = @user.events.where('start_datetime >= ? ', now.to_date).order('start_datetime DESC')
    history_events = @user.events.where('start_datetime < ? ', now.to_date).order('start_datetime DESC')
    render status: 200, json: { future_events: future_events, history_events: history_events }
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile, :avatar)
  end

  def set_user
    user_id = params[:user_id].present? ? params[:user_id] : params[:id]
    @user = User.find_by(id: user_id)
    render status: 404 if @user.nil?
  end
end
