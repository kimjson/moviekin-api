class SwaggerSchema
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

  swagger_schema :AnswerInput do
    allOf do
      schema do
        key :'$ref', :Answer
      end
      schema do
        key :required, [:content, :question_id]
        property :content do
          key :type, :string
        end
      end
    end
  end

  swagger_schema :ErrorModel do
    key :required, [:message]
    property :message do
      key :type, :string
    end
  end
end