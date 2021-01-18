class Api::TopController < ApplicationController
  
  def index
    news   = News.all.order('created_at DESC').limit(3)
    events = Event.where('start_datetime >= ?', Time.now.in_time_zone.to_date)
                  .order('start_datetime').limit(3)
    render status: 200, json: { events: events, news: news }
  end
end
