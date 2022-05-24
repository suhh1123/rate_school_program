FactoryBot.define do
  factory :user do
    first_name { "sample_f_name" }
    last_name { "sample_l_name" }
    sequence(:email) { |n| "sample_email_#{n}" }
    sequence(:username) { |n| "sample_username_#{n}" }
  end
end
