# frozen_string_literal: true

# Handle 404, 422 error
module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  included do
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
end
