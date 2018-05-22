FactoryBot.define do
  factory :answer do
    content { FFaker::Lorem.sentences }
    question_id "1"
  end
end