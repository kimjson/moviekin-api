# frozen_string_literal: true

# Serialize movie model
class MovieSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :kmdb_docid, :director, :nation, :production_year
  attribute :release_date do |object|
    object.release_date.strftime('%Y-%m-%d')
  end
  has_many :questions
end
