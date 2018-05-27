class Api::V1::ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Moviekin API'
      key :description, 'REST API backend (in Ruby on Rails) of MovieKin, a stackoverflow clone service for cinema audiences.'
      key :termsOfService, 'None yet'
      contact do
        key :name, 'Stein Kim'
      end
      license do
        key :name, 'AGPL-3.0'
      end
    end
    tag do
      key :name, 'answer'
      key :description, 'Answers operations'
      externalDocs do
        key :description, 'None yet'
        key :url, ''
      end
    end
    key :host, 'localhost:3000'
    key :basePath, ''
    key :consumes, ['application/json']
    key :produces, ['application/json']
    parameter :answer_id do
      key :name, :id
      key :in, :path
      key :description, 'ID of answer to fetch'
      key :required, true
      key :type, :integer
      key :format, :int64
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    self,
    SwaggerPath,
    SwaggerSchema,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end