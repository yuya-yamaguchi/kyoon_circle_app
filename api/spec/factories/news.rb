FactoryBot.define do
  factory :news do
    title          {"a" * 40}
    details        {"a" * 1000}
    line_msg_push  {true}
  end
end
