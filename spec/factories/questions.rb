FactoryBot.define do
  factory :question do
    title { FFaker::Lorem.sentence }
    content { FFaker::Lorem.sentences }
  end
end