FactoryBot.define do
  factory :user do
    first_name { "sample_f_name" }
    last_name { "sample_l_name" }
    sequence(:email) { |n| "sample#{n}@example.com" }
    sequence(:username) { |n| "sample_username_#{n}" }
  end
end
