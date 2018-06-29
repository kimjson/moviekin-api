# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    title { FFaker::Movie.title }
    kmdb_docid { FFaker::String.from_regexp(/[0-9]{5,}/) }
    director { FFaker::Name.name }
    nation { FFaker::Address.country }
    release_date { FFaker::Time.date }
    production_year { Random.rand(1896..9999) }
  end
end
