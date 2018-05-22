class Question < ApplicationRecord
  validates :title, :content, presence: true
  
  has_many :answers, dependent: :destroy
end
