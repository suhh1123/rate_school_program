FactoryBot.define do
  factory :school do
    sequence(:name) { |n| "sample_name_#{n}" }
    address { "sample_address" }
    city { "sample_city" }
    state { "sample_state" }
    zipcode { 10027 }
    country { "sample_country" }
  end
end
