class Api::Admin::StudiosController < ApplicationController
  before_action :set_studio

  def edit
    render json: @studio
  end

  def update
    if @studio.update(studio_params)
      render status: 204
    else
      render status: 422, json: @studio.errors.full_messages
    end
  end

  private
  def studio_params
    params.require(:studio).permit(:name, :fee)
  end

  def set_studio
    @studio = Studio.find_by(id: params[:id])
    render status: 404 if @studio.nil?
  end
end
