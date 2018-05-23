class Api::V1::AnswersController < ApplicationController
  include Swagger::Blocks

  swagger_path '/answers/{id}' do
    operation :get do
      key :summary, 'Find Answer by ID'
      key :description, 'Returns a single answer'
      key :operationId, 'findAnswerById'
      key :tags, [
        'answer'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of answer to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end 
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

  def show
    render json: Answer.find(params[:id])
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

  def index
    render json: Answer.all
  end

end
