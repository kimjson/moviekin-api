class Movie < ApplicationRecord
  validates :name, :code, :director, :open_year, :production_year, presence: true
  validates :open_year, :production_year,
            numericality: { greater_than_or_equal_to: 1896 },
            presence: true
end
