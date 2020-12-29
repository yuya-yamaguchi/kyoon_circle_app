class Api::TopController < ApplicationController
  
  def index
    out_params = []
    events = Event.all
    events.each do |event|
      out_params << event.set_out_params
    end
    render json: out_params
  end
end
