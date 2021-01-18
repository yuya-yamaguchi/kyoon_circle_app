class Api::StudiosController < ApplicationController
  
  def show
    studio = Studio.find(params[:id])
    reserves_params, weeks = studio.week_reserve(params)
    render status: 200, json: { studio: studio, reserves: reserves_params, weeks: weeks }
  end
end
