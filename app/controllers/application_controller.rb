# frozen_string_literal: true

# Base controller class for model controllers
class ApplicationController < ActionController::API
  include ExceptionHandler

  private
  # yield: serializer got from child controller
  def json_response(args)
    serialized_args = args.clone
    serialized_args[:json] = yield.new(args[:data])
    render serialized_args
  end

end
