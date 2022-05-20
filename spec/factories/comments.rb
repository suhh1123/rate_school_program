FactoryBot.define do
  factory :comment do
    title { "sample_title" }
    content { "sample_content" }
    user { nil }
    program { nil }
  end
end
