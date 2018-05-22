FactoryBot.define do
  factory :answer do
    content { FFaker::Lorem.sentences }
    question
  end
end