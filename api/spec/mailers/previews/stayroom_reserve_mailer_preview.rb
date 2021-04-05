# Preview all emails at http://localhost:3000/rails/mailers/stayroom_reserve_mailer
class StayroomReserveMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/stayroom_reserve_mailer/stayroom_reserved_email
  def stayroom_reserved_email
    StayroomReserveMailer.stayroom_reserved_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/stayroom_reserve_mailer/stayroom_cancel_email
  def stayroom_cancel_email
    StayroomReserveMailer.stayroom_cancel_email
  end

end
