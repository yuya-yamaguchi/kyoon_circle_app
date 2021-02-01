class Api::UsersController < ApplicationController
  before_action :set_user

  def show
    user_instruments = @user.set_instruments
    render status: 200, json: { user: @user, user_instruments: user_instruments }
  end

  private
  def set_user
    @user = User.find_by(id: params[:id])
    render status: 404 if @user.nil?
  end
end
