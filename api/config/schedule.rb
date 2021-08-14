# Rails.rootを使用するために設定
require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, 'log/cron.log'
ENV.each { |k, v| env(k, v) }

every 1.day, at: '6:00 pm' do
  rake 'notification:remind_studio_reserve_day_before'
end

# Learn more: http://github.com/javan/whenever
