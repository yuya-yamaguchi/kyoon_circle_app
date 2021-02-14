class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  def auth_check
    return render status: 401, json:{ error_message: "ログインまたは会員登録を行ってください。" } if request.headers['Authorization'].blank?
    @user = set_current_user
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if @user.nil?
  end

  def admin_check
    @user = set_current_user
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if @user.nil?
    return render status: 403, json:{ error_message: "操作権限がありません" } if @user.admin_type == 0
  end

  private
  def set_current_user
    User.find_by(token: request.headers['Authorization'])
  end
end
