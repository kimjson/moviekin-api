# frozen_string_literal: true

# Base controller class for model controllers
class ApplicationController < ActionController::API
  before_action :setup

  # child class should initialize serializer in this method.
  def setup; end

  def json_response(args)
    options = {}
    options[:include] = params[:include].split(',') if params.key? :include

    payload = args.extract!(:status, :location)
    payload[:json] = @serializer.new(args[:data], options)

    render payload
  end

  # handling exceptions
  rescue_from ActiveRecord::RecordNotFound do |e|
    render status: 404, json: {
      errors: [
        {
          status: 404,
          title: "#{e.model} not found",
          detail: "#{e.model} not found"
        }
      ]
    }
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render status: 422, json: {
      errors: ValidationErrorsSerializer.new(e.record).serialize
    }
  end
end
