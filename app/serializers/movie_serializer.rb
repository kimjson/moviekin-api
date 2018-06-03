class MovieSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :code, :director, :open_year, :production_year
  has_many :questions
end
