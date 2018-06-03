class AnswerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :content, :question_id
  belongs_to :question
  has_one :question
end
