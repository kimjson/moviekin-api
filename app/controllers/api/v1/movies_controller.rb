# frozen_string_literal: true

module Api
  module V1
    # CRUD controller for movie model.
    class MoviesController < ApplicationController
      def show
        json_response data: Movie.find(params[:id]), options: params
      end

      def index
        json_response data: Movie.all
      end

      def create
        Rails.logger.debug "movie_params: #{movie_params}"
        movie = Movie.create!(movie_params)
        json_response data: movie, status: 201, location: [:api, movie]
      end

      def update
        movie = Movie.find(params[:id])
        movie.update!(movie_params)
        json_response data: movie, status: 200, location: [:api, movie]
      end

      def destroy
        Movie.find(params[:id]).destroy!
        head 204
      end

      private

      def movie_params
        movie_attributes = %i[
          title kmdb_seq director nation release_date production_year
        ]
        params.require(:data)
              .permit(:type, :relationships, attributes: movie_attributes)
              .require(:attributes)
              .permit(*movie_attributes)
      end
    end
  end
end
