# frozen_string_literal: true

# Handle 404, 422 error
module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern
  
  included do
    # rescue_from Exceptions::RecordNotFound do |e|
    #   json_error title: e.title, detail: e.detail, status: 404
    # end
    rescue_from ActiveRecord::RecordNotFound do |e|
      render status: 404, json: {
        errors: [
          {
            status: 404,
            title: "#{e.model not found}",
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

    rescue_from StandardError do |e|
      render status: 500, json: {
        errors: [
          status: 500,
          title: 'Unknown error',
          detail: 'Unknown error. Contact API developer',
        ]
      } 
    end
  end
end
