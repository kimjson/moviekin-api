class Api::V1::SwaggerPath
  include Swagger::Blocks

  swagger_path '/answers/{id}' do
    operation :get do
      key :summary, 'Find Answer by ID'
      key :description, 'Returns a single answer'
      key :operationId, 'findAnswerById'
      key :tags, [
        'answer'
      ]
      parameter :answer_id
      response 200 do
        key :description, 'answer response'
        schema do
          key :'$ref', :Answer
        end
      end
      response 404 do
        key :description, 'answer not found'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  swagger_path '/answers' do
    operation :get do
      key :summary, 'All Answers'
      key :description, 'Returns all answers'
      key :operationId, 'findAnswers'
      key :produces, [
        'application/json',
      ]
      key :tags, [
        'answer'
      ]
      response 200 do
        key :description, 'answer response'
        schema do
          key :type, :array
          items do
            key :'$ref', :Answer
          end
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  swagger_path '/questions/{id}/answers' do
    operation :post do
      key :summary, 'Answer to a question'
      key :description, 'Create an Answer object related to the Question object it is answering to'
      key :operationId, 'addAnswerToQuestion'
      key :produces, [
        'application/json',
      ]
      key :tags, [
        'answer'
      ]
      response 201 do
        key :description, 'answer added'
        schema do
          key :'$ref', :Answer
        end
      end
      response 404 do
        key :description, 'question not found'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      response 422 do
        key :description, 'invalid answer schema'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
end