# frozen_string_literal: true

# Define question model field validation and relationship
class Question < ApplicationRecord
  validates :title, :content, :movie_id, presence: true
  has_many :answers, dependent: :destroy
  belongs_to :movie
end
