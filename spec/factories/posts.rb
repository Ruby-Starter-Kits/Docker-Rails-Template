FactoryBot.define do
  factory :post do
    title { Faker::Beer.name }
    body { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
