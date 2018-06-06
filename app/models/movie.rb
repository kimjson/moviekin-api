# frozen_string_literal: true

# Define movie model field validation and relationship
class Movie < ApplicationRecord
  validates :name, :code, :director, presence: true
  validates :open_year, :production_year,
            numericality: { greater_than_or_equal_to: 1896 },
            presence: true

  has_many :questions, dependent: :destroy
end
