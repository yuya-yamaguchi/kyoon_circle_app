class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def auth_check
    if request.headers['Authorization'].blank?
      return render status: 401,
                    json: { error_message: 'ログインまたは会員登録を行ってください。' }
    end
    set_current_user
    return render status: 401, json: { error_message: '認証に失敗しました。再度ログインしてお試しください。' } if @current_user.nil?
  end

  def admin_check
    set_current_user
    return render status: 401, json: { error_message: '認証に失敗しました。再度ログインしてお試しください。' } if @current_user.nil?
    return render status: 403, json: { error_message: '操作権限がありません' } if @current_user.admin_type == 0
  end

  def set_current_user
    @current_user = User.find_by(token: request.headers['Authorization'])
  end
end
