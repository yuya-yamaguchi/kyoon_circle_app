class Api::MypageController < ApplicationController

  def show
    user = User.find(params[:id])
    render json: user
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render status: 200
    else
      render status: 500
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile)
  end
end
