class Api::Admin::UsersController < ApplicationController
  
  def index
    users = User.order('name').select(:id, :name, :email, :admin_type)
    render status: 200, json: users
  end
end
