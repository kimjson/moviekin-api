# frozen_string_literal: true

require 'http'
require 'time'
class MovieWorker
  include Sidekiq::Worker

  KOFA_API_BASE_URL = 'http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json.jsp'

  KOFA_API_KEY = api_key

  def api_key
    if Rails.env.production?
      Rails.application.credentials.kofa[:production]
    else
      Rails.application.credentials.kofa[:dev]
    end
  end

  def perform
    conn = Faraday.new(url: KOFA_API_BASE_URL) do |faraday|
      faraday.response :logger do |logger|
        logger.filter(/(ServiceKey=)(\w+)/, '\1[REMOVED]')
      end
      faraday.adapter Faraday.default_adapter
    end
    response = conn.get(
      '/openapi-data2/wisenut/search_api/search_json.jsp',
      'ServiceKey' => KOFA_API_KEY,
      'collection' => 'kmdb_new',
      'detail' => 'Y'
    )
  end
end
