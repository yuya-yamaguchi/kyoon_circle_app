# Rails.rootを使用するために設定
require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, 'log/cron.log'
ENV.each { |k, v| env(k, v) }

every 1.minute do
  runner "Batch::SendEmail.studio_reserves_remind_email"
end

# Learn more: http://github.com/javan/whenever
