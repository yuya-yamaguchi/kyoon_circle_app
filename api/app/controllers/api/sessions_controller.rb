class Api::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render status: 201, json: user
    else
      render status: 400
    end
  end
end
