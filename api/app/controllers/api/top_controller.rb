class Api::TopController < ApplicationController
  
  def index
    news   = News.recent(3)
    events = Event.recent(3)
    render status: 200, json: { events: events, news: news }
  end
end
