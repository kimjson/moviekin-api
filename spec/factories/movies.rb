FactoryBot.define do
  factory :movie do
    name { FFaker::Movie.title }
    code { FFaker::String.from_regexp /[0-9]{8}/ }
    director { FFaker::Name.name }
    open_year { 1896 + Random.rand(8105) }
    production_year { 1896 + Random.rand(8105) }
  end
end
