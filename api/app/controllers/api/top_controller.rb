class Api::TopController < ApplicationController
  
  def index
    event_params = []
    # お知らせの取得
    news = News.all.order('created_at DESC').limit(3)
    # イベント一覧の取得
    events = Event.where('start_datetime >= ?', Time.now.in_time_zone.to_date)
                  .order('start_datetime').limit(3)
    events.each do |event|
      event_params << event.set_out_params
    end
    render json: { events: event_params, news: news }
  end
end
