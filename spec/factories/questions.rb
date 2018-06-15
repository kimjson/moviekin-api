# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { FFaker::Lorem.sentence }
    content { FFaker::Lorem.paragraph }
    movie
  end
end
