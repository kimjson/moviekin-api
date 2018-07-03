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

  def fetch_movies(start_date, end_date, type, list_count)
    JSON.parse(correct_json(conn.get(
      '/openapi-data2/wisenut/search_api/search_json.jsp',
      'ServiceKey' => KOFA_API_KEY,
      'collection' => 'kmdb_new',
      'detail' => 'Y',
      'releaseDts' => start_date,
      'releaseDte' => end_date,
      'type' => type,
      'listCount' => list_count
    ).body), symbolize_names: true)[:Data][0].fetch(:Result, [])
  end

  def correct_json(json)
    json.gsub(',]', ']')
        .gsub('}{', '},{')
  end

  def create_movie_from_kmdb(kmdb_movie)
    movie = Movie.new
    movie.title = kmdb_movie[:title]
    movie.kmdb_docid = kmdb_movie[:DOCID]
    movie.director = kmdb_movie[:director][0][:directorNm]
    movie.production_year = kmdb_movie[:prodYear]
    movie.release_date = kmdb_movie[:rating][0][:releaseDate]
    movie.nation = kmdb_movie[:nation]
    movie.save!
    movie
  end

  def perform_result(type, kmdb_movies, movies)
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

  # start_date (string): (YYYYMMDD) release date start
  # end_date (string): (YYYYMMDD) release date end
  def perform(start_date:, end_date:, type: '극영화', list_count: 100)
    puts "Start fetching #{type} movies released last week..."
    # validate required parameter
    # start_date, end_date should be valid dates(check this by try parsing).
    # start_date should be before than or equal end_date.
    raise ArgumentError unless Date.parse(start_date) <= Date.parse(end_date)
    movies = []
    kmdb_movies = fetch_movies(start_date, end_date, type, list_count)
    kmdb_movies.each do |kmdb_movie|
      next unless Movie.find_by(kmdb_docid: kmdb_movie[:DOCID]).nil?
      movies << create_movie_from_kmdb(kmdb_movie)
    end
    perform_result type, kmdb_movies, movies
  end
end
