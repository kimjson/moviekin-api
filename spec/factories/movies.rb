# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    name { FFaker::Movie.title }
    code { FFaker::String.from_regexp(/[0-9]{8}/) }
    director { FFaker::Name.name }
    open_year { Random.rand(1896..9999) }
    production_year { Random.rand(1896..9999) }
  end
end
