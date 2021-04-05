class StayroomReserveMailer < ApplicationMailer

  def stayroom_reserved_email(stayroom_reserve, user)
    @user = user
    @stayroom_reserve = stayroom_reserve
    mail(to: @user.email, subject: '【京音Webサイト】宿泊予約完了のお知らせ')
  end

  def stayroom_cancel_email(stayroom_reserve, user)
    @user = user
    @stayroom_reserve = stayroom_reserve
    mail(to: @user.email, subject: '【京音Webサイト】宿泊予約キャンセルのお知らせ')
  end
end
