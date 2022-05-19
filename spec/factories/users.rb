FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "sample_f_name_#{n}" }
    sequence(:last_name) { |n| "sample_l_name_#{n}" }
    sequence(:email) { |n| "sample_email_#{n}" }
    sequence(:username) { |n| "sample_username_#{n}" }
    sequence(:password_hash) { |n| "sample_password_hash_#{n}" }
  end
end
