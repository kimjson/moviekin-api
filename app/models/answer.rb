class Answer < ApplicationRecord
  validates :content, :question_id, presence: true
end
