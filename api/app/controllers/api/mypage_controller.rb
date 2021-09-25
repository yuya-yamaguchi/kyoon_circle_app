class Api::MypageController < ApplicationController
  include Pagy::Backend

  before_action :auth_check

  def show
    user_instruments = @current_user.set_instruments
    user = @current_user.set_follow_count
    render status: 200, json: { user: user, user_instruments: user_instruments }
  end

  # スタジオ予約
  def future_studio_reserves
    pagy, future_reserves = pagy(@current_user.studio_reserves.after_today_desc, items: 10)
    render status: 200, json: { future_reserves: future_reserves, pagy: pagy_metadata(pagy) }
  end

  # スタジオ予約履歴
  def history_studio_reserves
    pagy, history_reserves = pagy(@current_user.studio_reserves.bofore_today_desc, items: 10)
    render status: 200, json: { history_reserves: history_reserves, pagy: pagy_metadata(pagy) }
  end
  
  # 参加予定のイベント
  def future_events
    pagy, future_events = pagy(@current_user.events.after_today.order_date_desc, items: 10)
    out_future_params = future_events.map { |future_event| future_event.set_index_params(@current_user) }
    render status: 200, json: { future_events: out_future_params, pagy: pagy_metadata(pagy) }
  end
  
  # 過去の参加イベント
  def history_events
    pagy, history_events = pagy(@current_user.events.before_today.order_date_desc, items: 10)
    out_history_params = history_events.map { |history_event| history_event.set_index_params(@current_user) }
    render status: 200, json: { history_events: out_history_params, pagy: pagy_metadata(pagy) }
  end

  def stayroom_reserves
    future_reserves  = StayroomReserve.feature_reserves(@current_user.id)
    history_reserves = StayroomReserve.history_reserves(@current_user.id)
    render status: 200, json: { future_reserves: future_reserves, history_reserves: history_reserves }
  end

  def messages
    messagerooms = @current_user.messagerooms
    messages_list = messagerooms.map { |messageroom| messageroom.get_messages_list(@current_user.id) }.compact
    messages_list.sort_by! { |message| message[:created_at] }.reverse!
    render status: 200, json: { messages_list: messages_list }
  end
end
