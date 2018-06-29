# frozen_string_literal: true

require 'http'
require 'time'
require 'sidekiq-scheduler'
# Sidekiq worker class for fetching movies
class MovieWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  KOFA_API_BASE_URL = 'http://api.koreafilm.or.kr/openapi-data2/wisenut' \
                      '/search_api/search_json.jsp'

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
    movies = []

    # change hard coded date strings.
    response = conn.get(
      '/openapi-data2/wisenut/search_api/search_json.jsp',
      'ServiceKey' => KOFA_API_KEY,
      'collection' => 'kmdb_new',
      'detail' => 'Y',
      'releaseDts' => '20180623',
      'releaseDte' => '20180629',
      'type' => '극영화',
      'listCount' => 100
    )
    json = JSON.parse(response.body.gsub(',]', ']'), symbolize_names: true)
    kmdb_movies = json[:Data][0][:Result]
    
    kmdb_movies.each do |kmdb_movie|
      if Movie.find_by(kmdb_docid: kmdb_movie[:DOCID]).nil?
        # creat movie object
        movie = Movie.new
        movie.title = kmdb_movie[:title]
        movie.kmdb_docid = kmdb_movie[:DOCID]
        movie.director = kmdb_movie[:director][0][:directorNm]
        movie.production_year = kmdb_movie[:prodYear]
        movie.release_date = kmdb_movie[:rating][0][:releaseDate]
        movie.nation = kmdb_movie[:nation]
        movies << movie if movie.save
      end
    end
    puts "Fetched movies: #{kmdb_movies.length}"
    puts "Stored movies: #{movies.length}"
    movies
  end
end
