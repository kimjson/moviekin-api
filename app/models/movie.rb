# frozen_string_literal: true

# Define movie model field validation and relationship
class Movie < ApplicationRecord
  validates :title, :kmdb_docid, :director, :nation, presence: true
  validates :release_date,
            presence: true,
            timeliness: { type: :date }
  validates :production_year,
            presence: true,
            numericality: { greater_than_or_equal_to: 1896 }

  validates :kmdb_docid, uniqueness: true
  has_many :questions, dependent: :destroy
end
