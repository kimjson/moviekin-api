class Answer < ApplicationRecord
  include Swagger::Blocks

  swagger_schema :Answer do
    key :required, [:id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :content do
      key :type, :string
    end
    property :question_id do
      key :type, :integer
      key :format, :int64
    end
  end

  validates :content, :question_id, presence: true
  belongs_to :question
end
