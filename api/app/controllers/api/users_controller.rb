class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :auth_check, only: [:update]

  def show
    user_instruments = @user.set_instruments
    render status: 200, json: { user: @user, user_instruments: user_instruments }
  end

  def create
    user = User.new(user_params)
    if user.save
      render status: 201, json: user
    else
      render status: 422, json: user.errors.full_messages
    end
  end

  def update
    if @user.update(user_params)
      render status: 200, json: @user
    else
      render status: 422, json: @user.errors.full_messages
    end
  end

  private
  def set_user
    @user = User.find_by(id: params[:id])
    render status: 404 if @user.nil?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile, :avatar, { :instrument_ids => [] })
  end
end
