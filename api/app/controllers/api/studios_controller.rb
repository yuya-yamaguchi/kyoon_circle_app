class Api::StudiosController < ApplicationController
  
  def show
    studio = Studio.find(params[:id])
    render status: 200, json: { studio: studio }
  end
end
