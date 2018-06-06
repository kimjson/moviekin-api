# frozen_string_literal: true

# Base controller class for model controllers
class ApplicationController < ActionController::API
  include ExceptionHandler
end
