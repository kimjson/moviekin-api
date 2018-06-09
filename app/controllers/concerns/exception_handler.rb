# frozen_string_literal: true

# Handle 404, 422 error
module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern
  
  DEFAULT_TITLE = 'Internal Server Error'
  DEFAULT_DETAIL = 'It implies problems with backend logic. Contact api develeoper.'
  
  def json_error(status=500, title=DEFAULT_TITLE, detail=DEFAULT_DETAIL, source=null)
    error_hash = Hash.new
    error_hash[:title] = title
    error_hash[:detail] = detail
    if not source.nil? then
      error_hash[:source] = source
    end
    render json: { errors: [error_hash] }, status: status
  end

  included do
    # rescue_from Exceptions::RecordNotFound do |e|
    #   json_error title: e.title, detail: e.detail, status: 404
    # end
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message }, status: 404
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { message: e.message }, status: 422
    end
  end
end
