class Api::Admin::Studio::ReservesController < ApplicationController
  before_action :admin_check
  
  def index
    studio = Studio.find_by(id: params[:studio_id])
    reserves_params, weeks = studio.week_reserve(params)
    render status: 200, json: { studio: studio, reserves: reserves_params, weeks: weeks }
  end
end
