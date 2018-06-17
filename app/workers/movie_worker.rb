require 'http'
require 'time'
class MovieWorker
  include Sidekiq::Worker

  KOFIC_API_KEY = Rails.application.credentials.kofic.dev
  KOFIC_API_BASE_URL = 'http://www.kobis.or.kr/kobisopenapi/webservice/rest'

  KOFA_API_KEY = Rails.application.credentials.kofa.dev

  # target_time: object of class Time
  def perform(target_time)
    # Do something
    target_dt = target_time.strftime('%Y%m%d') 
    response = HTTP.get("#{KOFIC_API_BASE_URL}/boxoffice/searchDailyBoxOfficeList.json?key=#{KOFIC_API_KEY}targetDt=#{target_dt}")
    movie_list = []
    if response.code == 200 then
      movie_list = JSON.parse(response.body)['boxOfficeResult']['dailyBoxOfficeList']
    end
  end
end
