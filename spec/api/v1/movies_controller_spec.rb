# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/request_helpers'
require 'shared_examples'

RSpec.configure do |c|
  c.include Request::JsonHelpers
end

RSpec.describe Api::V1::MoviesController, type: :request do
  describe 'GET #show' do
    context 'when the record exists' do
      before(:each) do
        @movie = FactoryBot.create :movie
        3.times { FactoryBot.create :question, movie: @movie }
        get "/movies/#{@movie.id}"
      end

      it 'returns the movie' do
        movie_response = json_response[:data]
        expect(movie_response).not_to be_empty
        expect(movie_response[:id]).to eql @movie.id.to_s
        expect(movie_response[:attributes][:name]).to eql @movie.name
        expect(movie_response[:attributes][:code]).to eql @movie.code
        expect(movie_response[:attributes][:director]).to eql @movie.director
        expect(movie_response[:attributes][:open_year]).to eql @movie.open_year
        expect(movie_response[:attributes][:production_year]).to(
          eql @movie.production_year
        )
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before(:each) do
        get '/movies/100'
      end

      include_examples 'not found', 'movie'
    end
  end

  describe 'GET #index' do
    include_examples 'returns 4 records from the database', 'movie'
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @movie_attributes = FactoryBot.attributes_for :movie
        post '/movies', params: {
          data: {
            type: 'movie',
            attributes: @movie_attributes
          }
        }
      end

      it 'renders the json representation for the movie record just created' do
        movie_response = json_response[:data]

        expect(movie_response).not_to be_empty
        @movie_attributes.each do |key, value|
          expect(movie_response[:attributes][key]).to eql value
        end
      end

      it { expect(response).to have_http_status(201) }
    end

    context 'field validation error' do
      before(:each) do
        @invalid_movie_attributes = {
          name: nil,
          code: 'hello',
          director: 1,
          open_year: 'hey you',
          production_year: 'bye bye'
        }
        post '/movies', params: {
          data: {
            type: 'movie',
            attributes: @invalid_movie_attributes
          }
        }
      end

      include_examples 'field validation error result', 'movie'
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @movie = FactoryBot.create :movie
    end

    context 'when is successfully updated' do
      before(:each) do
        patch "/movies/#{@movie.id}", params: {
          data: {
            type: 'movie',
            attributes: {
              name: 'Updated name',
              code: 'Updated code'
            }
          }
        }
      end

      it 'ID did not change after update' do
        expect(json_response[:data][:id]).to eql @movie.id.to_s
      end

      include_examples 'response attributes correct', {
        name: 'Updated name',
        code: 'Updated code'
      }

      it { expect(response).to have_http_status(200) }
    end

    context 'cannot find movie record to update' do
      before(:each) do
        patch '/movies/100', params: {
          data: {
            type: 'movie',
            attributes: { name: 'Updated name' }
          }
        }
      end

      include_examples 'not found', 'movie'
    end

    context 'field validation error' do
      before(:each) do
        patch "/movies/#{@movie.id}", params: {
          data: {
            type: 'movie',
            attributes: { name: nil }
          }
        }
      end

      include_examples 'field validation error result', 'movie'
    end
  end
  describe 'DELETE #destroy' do
    before(:each) do
      @movie = FactoryBot.create :movie
      delete "/movies/#{@movie.id}"
    end

    it { expect(response).to have_http_status(204) }
  end
end
