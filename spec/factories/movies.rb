# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    title { FFaker::Movie.title }
    sequence(:kmdb_docid, 10_000) { |n| "F#{n}" }
    director { FFaker::Name.name }
    nation { FFaker::Address.country }
    release_date { FFaker::Time.date }
    production_year { Random.rand(1896..9999) }
  end
end
