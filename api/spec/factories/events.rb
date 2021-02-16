FactoryBot.define do
  factory :event do
    title          { 'a' * 40 }
    details        { 'a' * 1000 }
    place          { 'a' * 100 }
    fee            { 'a' * 20 }
    max_entry      { 0 }
    start_datetime { '2021-01-01' }
    end_datetime   { '2021-01-01' }
    event_type     { 1 }
    line_msg_push  { true }
    user
  end
end
