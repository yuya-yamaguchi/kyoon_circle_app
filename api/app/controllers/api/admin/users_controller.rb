class Api::Admin::UsersController < ApplicationController
  
  def index
    users = User.all
    render status: 200, json: users
  end

  def update
    binding.pry
  end
end
