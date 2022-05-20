FactoryBot.define do
  factory :program do
    sequence(:title) { |n| "sample_title_#{n}" }
    school { nil }
  end
end
