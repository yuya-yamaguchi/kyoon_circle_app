class Api::TopController < ApplicationController
  
  def index
    news   = News.recent(3)
    events = Event.recent(3)
    events_params = []
    events.each do |event|
      events_params << event.set_index_params
    end
    render status: 200, json: { events: events_params, news: news }
  end
end
