FactoryBot.define do
  factory :user do
    first_name { "sample_f_name" }
    last_name { "sample_l_name" }
    email { "sample_email" }
    username { "sample_username" }
  end
end
