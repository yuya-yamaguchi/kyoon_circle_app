class Api::StayroomsController < ApplicationController
  def index
    stayrooms = Stayroom.all.order('id')
    render status: 200, json: { stayrooms: stayrooms }
  end
end
