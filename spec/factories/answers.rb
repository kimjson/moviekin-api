# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    content { FFaker::Lorem.paragraph }
    question
  end
end
