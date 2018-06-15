# frozen_string_literal: true

# Define answer model field validation and relationship
class Answer < ApplicationRecord
  validates :content, :question_id, presence: true
  belongs_to :question
end
