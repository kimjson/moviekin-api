class Question < ApplicationRecord

  validates :title, :content, :movie_id, presence: true
  has_many :answers, dependent: :destroy
  belongs_to :movie
end
