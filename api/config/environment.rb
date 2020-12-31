# Load the Rails application.
require_relative 'application'

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular "reserve", "reserves"
  inflect.irregular "user_reserve", "user_reserves"
end

# Initialize the Rails application.
Rails.application.initialize!
