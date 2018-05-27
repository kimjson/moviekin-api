class Answer < ApplicationRecord

  validates :content, :question_id, presence: true
  belongs_to :question
end
