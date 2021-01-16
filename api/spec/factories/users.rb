FactoryBot.define do
  factory :user do
    name                  {"a" * 20}
    profile               {"a" * 1000}
    email                 {"a@gmail.com"}
    password              {"password"}
    password_confirmation {"password"}
  end
end
