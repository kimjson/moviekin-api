require 'http'
require 'time'
class MovieWorker
  include Sidekiq::Worker

  KOFIC_API_KEY = Rails.application.credentials.kofic.dev
  KOFIC_API_BASE_URL = 'http://www.kobis.or.kr/kobisopenapi/webservice/rest'

  KOFA_API_BASE_URL = 'http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json.jsp'

  KOFA_API_BASE_URL = %Q{
    http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json.jsp
    ?collection=kmdb_new&detail=Y&ServiceKey=#{api_key}
  }

  def api_key
    if Rails.env.production?
      Rails.application.credentials.kofa.production
    else
      Rails.application.credentials.kofa.dev
    end
  end


  # target_time: object of class Time
  def perform
    # Do something
    conn = Faraday.new(:url => KOFA_API_BASE_URL) do |faraday|
      faraday.response :logger do | logger |
        logger.filter(/(ServiceKey=)(\w+)/,'\1[REMOVED]')
      end
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    target_dt = target_time.strftime('%Y%m%d') 
    response = conn.get '/', {
      'ServiceKey' => api_key,
      'collection' => 'kmdb_new',
      'detail' => 'Y',
    }
    puts response.body
    # movie_list = []
    # if response.code == 200 then
    #   movie_list = JSON.parse(response.body)['boxOfficeResult']['dailyBoxOfficeList']
    # end
  end
end
