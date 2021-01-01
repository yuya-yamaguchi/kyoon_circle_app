class Api::Admin::StudiosController < ApplicationController

  def edit
    studio = Studio.find(params[:id])
    render json: studio
  end

  def update
    studio = Studio.find(params[:id])
    if studio.update(studio_params)
      render status: 200
    else
      render status: 500
    end
  end

  private
  def studio_params
    params.require(:studio).permit(:name, :fee)
  end
end
