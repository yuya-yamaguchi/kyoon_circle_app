FactoryBot.define do
  factory :user do
    name                  {"a" * 20}
    profile               {"a" * 1000}
    email                 {"a@gmail.com"}
    password              {"password"}
    password_confirmation {"password"}
    admin_type            {0}
    
    trait :admin do
      email               {"admin@gmail.com"}
      admin_type          {1}
    end
  end
end
