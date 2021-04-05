# Preview all emails at http://localhost:3000/rails/mailers/studio_reserve_mailer
class StudioReserveMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/studio_reserve_mailer/studio_reserved
  def studio_reserved
    StudioReserveMailer.studio_reserved
  end

end
