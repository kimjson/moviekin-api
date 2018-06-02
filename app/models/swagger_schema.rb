class SwaggerSchema
  include Swagger::Blocks

  swagger_schema :Movie do
    key :required, [:id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :code do
      key :type, :string
    end
    property :director do
      key :type, :string
    end
    property :open_year do
      key :type, :integer
      key :format, :int32
    end
    property :production_year do
      key :type, :integer
      key :format, :int32
    end
  end

  swagger_schema :MovieInput do
    allOf do
      schema do
        key :'$ref', :Movie
      end
      schema do
        key :required, [:name, :code, :director]
        property :name do
          key :type, :string
        end
        property :code do
          key :type, :string
        end
        property :director do
          key :type, :string
        end
      end
    end
  end

  swagger_schema :Question do
    key :required, [:id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :title do
      key :type, :string
    end
    property :content do
      key :type, :string
    end
    property :movie_id do
      key :type, :integer
      key :format, :int64
    end
  end
  swagger_schema :QuestionInput do
    allOf do
      schema do
        key :'$ref', :Question
      end
      schema do
        key :required, [:title, :content, :movie_id]
        property :title do
          key :type, :string
        end
        property :content do
          key :type, :string
        end
      end
    end
  end

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