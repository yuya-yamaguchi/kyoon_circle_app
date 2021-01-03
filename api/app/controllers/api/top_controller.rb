class Api::TopController < ApplicationController
  
  def index
    out_params = []
    events = Event.where('start_datetime >= ?', Time.now.in_time_zone.to_date)
                  .order('start_datetime DESC')
    events.each do |event|
      out_params << event.set_out_params
    end
    render json: out_params
  end
end
