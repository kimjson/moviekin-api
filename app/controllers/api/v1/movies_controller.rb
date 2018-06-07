# frozen_string_literal: true

module Api
  module V1
    # CRUD controller for movie model.
    class MoviesController < ApplicationController
      SERIALIZER = MovieSerializer

      # TODO: embed answer object.
      def show
        movie_response data: Movie.find(params[:id])
      end

      def index
        movie_response data: Movie.all
      end

      def create
        movie = Movie.create!(movie_params)
        movie_response data: movie, status: 201, location: [:api, movie]
      end

      def update
        movie = Movie.find(params[:id])
        movie.update!(movie_params)
        movie_response data: movie, status: 200, location: [:api, movie]
      end

      def destroy
        Movie.find(params[:id]).destroy!
        head 204
      end

      private

      def movie_params
        params.require(:movie).permit(
          :name,
          :code,
          :director,
          :open_year,
          :production_year
        )
      end
      
      def movie_response(args)
        serialized_args = args.clone
        serialized_args[:json] = MovieSerializer.new(args[:data])
        render serialized_args
      end
    end
  end
end
