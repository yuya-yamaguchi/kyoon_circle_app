namespace :notification do

  desc 'スタジオ予約の前日にレコメンドのメールを送信'
  task remind_studio_reserve_day_before: :environment do
    Batch::SendEmail.studio_reserves_remind_email
  end
end