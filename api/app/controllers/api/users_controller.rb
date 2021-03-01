class Api::UsersController < ApplicationController
  before_action :set_current_user, only: [:show]
  before_action :set_user, only: [:show, :following, :followers]
  before_action :auth_check, only: [:update, :change_password, :following, :followers]

  def show
    user_instruments = @user.set_instruments
    user = @user.set_follow_count
    user_followed = @current_user.following?(@user) if @current_user.present?
    render status: 200, json: { user: user, user_instruments: user_instruments, user_followed: user_followed }
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
    if @current_user.update(user_params)
      render status: 200, json: @current_user
    else
      render status: 422, json: @current_user.errors.full_messages
    end
  end

  def following
    following_users = @user.following
    following_users_outparams = set_is_followed(following_users)
    render status: 200, json: { user: @user, following_users: following_users_outparams }
  end

  def followers
    followers = @user.followers
    followers_outparams = set_is_followed(followers)
    render status: 200, json: { user: @user, followers: followers_outparams }
  end

  def change_password
    if @current_user.authenticate(params[:user][:current_password])
      if @current_user.update(user_params)
        render status: 201
      else
        render status: 422, json: @current_user.errors.full_messages
      end
    else
      render status: 400, json: '現在のパスワードが正しくありません'
    end
  end

  def reset_password_email
    user = User.find_by(email: params[:email])
    if user.present?
      if user.send_reset_password_email
        render status: 200
      else
        render status: 400, json: 'メールの送信に失敗しました'
      end
    else
      render status: 401, json: 'メールアドレスのご登録がありません'
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
    user.reset_password_token = nil
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile, :avatar,
                                 { instrument_ids: [] })
  end

  def set_is_followed(follow_users)
    outparams = []
    current_user_followed_ids = @current_user.active_relationships.map{|relationship| relationship.followed_id}
    follow_users.each do |follow_user|
      outparams << follow_user.set_following_status(current_user_followed_ids)
    end
    outparams
  end
end
