class UserMailer < ApplicationMailer
  default from: 'kyoon.website@gmail.com'

  def reset_password_email(user)
    @user = user
    base_url = ''
    base_url = if Rails.env.development?
                 'http://localhost'
               else
                 Constants::APP_URL
               end
    @url = "#{base_url}/password/reset?token=#{@user.reset_password_token}"
    mail(to: @user.email, subject: '【京音Webサイト】パスワードの再設定')
  end
end
