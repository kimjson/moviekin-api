# frozen_string_literal: true

require 'http'
require 'time'
require 'sidekiq-scheduler'
# Sidekiq worker class for fetching movies
class MovieWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  KOFA_API_BASE_URL = 'http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json.jsp'

  KOFA_API_KEY = (
    if Rails.env.production?
      Rails.application.credentials.kofa[:production]
    else
      Rails.application.credentials.kofa[:dev]
    end
  )

  def conn
    Faraday.new(url: KOFA_API_BASE_URL) do |faraday|
      faraday.response :logger do |logger|
        logger.filter(/(ServiceKey=)(\w+)/, '\1[REMOVED]')
      end
      faraday.adapter Faraday.default_adapter
    end
  end

  def perform
    response = conn.get(
      '/openapi-data2/wisenut/search_api/search_json.jsp',
      'ServiceKey' => KOFA_API_KEY,
      'collection' => 'kmdb_new',
      'detail' => 'Y'
    )
    puts response.body
  end
end
