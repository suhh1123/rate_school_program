FactoryBot.define do
  factory :school do
    sequence(:name) { |n| "sample_school_#{n}" }
    address { "sample_address" }
    city { "sample_city" }
    state { "sample_city" }
    zipcode { 10027 }
    country { "sample_country" }
  end
end
