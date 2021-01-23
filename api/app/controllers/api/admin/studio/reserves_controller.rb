class Api::Admin::Studio::ReservesController < ApplicationController
  before_action :admin_check
  
  def index
    studio = Studio.find_by(id: params[:studio_id])
    reserves_params, weeks = studio.week_reserve(params)
    render status: 200, json: { studio: studio, reserves: reserves_params, weeks: weeks }
  end

  def admin_check
    @user = User.find_by(token: request.headers['Authorization'])
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if @user.nil?
    return render status: 403, json:{ error_message: "操作権限がありません" } if @user.admin_type == 0
  end
end
