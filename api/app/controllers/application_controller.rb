class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def auth_check
    @user = set_user
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if @user.nil?
  end

  def admin_check
    @user = set_user
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if @user.nil?
    return render status: 403, json:{ error_message: "操作権限がありません" } if @user.admin_type == 0
  end

  private
  def set_user
    User.find_by(token: request.headers['Authorization'])
  end
end
