# frozen_string_literal: true

# Define movie model field validation and relationship
class Movie < ApplicationRecord
  validates :title, :kmdb_seq, :director, :nation, presence: true
  validates :release_date,
            presence: true,
            timeliness: { type: :date }
  validates :production_year,
            presence: true,
            numericality: { greater_than_or_equal_to: 1896 }

  has_many :questions, dependent: :destroy
end
