class StudioReserveMailer < ApplicationMailer

  def studio_reserved_email(studio_reserve, user)
    @user = user
    @studio_reserve = studio_reserve
    mail(to: @user.email, subject: '【京音Webサイト】スタジオ予約完了のお知らせ')
  end
end
