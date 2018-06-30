# frozen_string_literal: true

require 'http'
require 'time'
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

  # releaseDts (string): (YYYYMMDD) release date start
  # releaseDte (string): (YYYYMMDD) release date end
  def perform(releaseDts:, releaseDte:, type: '극영화', listCount: 100)
    puts "Start fetching #{type} movies released last week..."

    # validate required parameter
    # releaseDts, releaseDte should be valid dates.
    # releaseDts should be before than or equal releaseDte.
    release_date_start = Date.parse releaseDts
    release_date_end = Date.parse releaseDte
    raise ArgumentError unless release_date_start <= release_date_end

    movies = []

    response = conn.get(
      '/openapi-data2/wisenut/search_api/search_json.jsp',
      'ServiceKey' => KOFA_API_KEY,
      'collection' => 'kmdb_new',
      'detail' => 'Y',
      'releaseDts' => releaseDts,
      'releaseDte' => releaseDte,
      'type' => type,
      'listCount' => listCount
    )
    json = JSON.parse(response.body.gsub(',]', ']'), symbolize_names: true)
    puts json
    kmdb_movies = json[:Data][0].fetch(:Result, [])

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
        movie.save!
        movies << movie
      end
    end
    puts "Fetched #{type} movies: #{kmdb_movies.length}"
    puts "Stored #{type} movies: #{movies.length}"
    puts "Finished fetching #{type} movies."
    {
      count: {
        fetched: kmdb_movies.length,
        stored: movies.length,
        duplicated: kmdb_movies.length - movies.length
      }
    }
  end
end
