class Api::UsersController < ApplicationController

  def show
    user = User.find_by(id: params[:id])
    if user
      render status: 200, json: user
    else
      render status: 404
    end
  end
end
