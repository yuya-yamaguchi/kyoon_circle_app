class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :auth_check, only: [:update, :change_password]

  def show
    user_instruments = @user.set_instruments
    render status: 200, json: { user: @user, user_instruments: user_instruments }
  end

  def create
    user = User.new(user_params)
    if user.save
      # UserMailer.with(user: @user).auth_email(@user).deliver_later
      UserMailer.auth_email(user).deliver
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

  def change_password
    if @user.authenticate(params[:user][:current_password])
      if @user.update(user_params)
        render status: 201
      else
        render status: 422, json: @user.errors.full_messages
      end
    else
      render status: 401, json: "現在のパスワードが正しくありません"
    end
  end

  def reset_password_email
    user = User.find_by(email: params[:email])
    if user.nil?
      render status: 401, json: "メールアドレスのご登録がありません"
    end
    if user.send_reset_password_email
      render status: 200
    else
      render status: 400, json: "メールの送信に失敗しました"
    end
  end

  def reset_password_token_check
    user = User.find_by(reset_password_token: params[:token])
    if user.present?
      render status: 200
    else
      render status: 422
    end
  end

  def reset_password
    user = User.find_by(reset_password_token: params[:token])
    if user.update(user_params)
      render status: 201
    else
      render status: 422, json: user.errors.full_messages
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
