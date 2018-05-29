class Api::V1::MoviesController < ApplicationController

  # TODO embed answer object.
  def show
    render json: Movie.find(params[:id])
  end

  def index
    render json: Movie.all
  end
  
  def create
    movie = Movie.create!(movie_params)
    render json: movie, status: 201, location: [:api, movie]
  end

  def update
    movie = Movie.find(params[:id])
    movie.update!(movie_params)
    render json: movie, status: 200, location: [:api, movie]
  end

  def destroy
    Movie.find(params[:id]).destroy!
    head 204
  end

  private

  def movie_params
    params.require(:movie).permit(:name, :code, :director, :open_year, :production_year)
  end
  
end
