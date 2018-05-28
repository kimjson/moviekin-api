FactoryBot.define do
  factory :question do
    title { FFaker::Lorem.sentence }
    content { FFaker::Lorem.paragraph }
  end
end