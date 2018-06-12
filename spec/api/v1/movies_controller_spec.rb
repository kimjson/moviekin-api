# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/request_helpers'

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

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        json_response[:errors].each do |error| 
          expect(error[:title]).to match(/^Movie not found$/)
          expect(error[:detail]).to match(/^Movie not found$/)
        end
      end
    end
  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryBot.create :movie }
      get '/movies'
    end

    it 'returns 4 records from the database' do
      movies_response = json_response[:data]
      expect(movies_response.size).to eq(4)
    end

    it { expect(response).to have_http_status(200) }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @movie_attributes = FactoryBot.attributes_for :movie
        post '/movies', params: { movie: @movie_attributes }
      end

      it 'renders the json representation for the movie record just created' do
        movie_response = json_response[:data]

        expect(movie_response).not_to be_empty
        expect(movie_response[:attributes][:name]).to(
          eql @movie_attributes[:name]
        )
        expect(movie_response[:attributes][:code]).to(
          eql @movie_attributes[:code]
        )
        expect(movie_response[:attributes][:director]).to(
          eql @movie_attributes[:director]
        )
        expect(movie_response[:attributes][:open_year]).to(
          eql @movie_attributes[:open_year]
        )
        expect(movie_response[:attributes][:production_year]).to(
          eql @movie_attributes[:production_year]
        )
      end

      it { expect(response).to have_http_status(201) }
    end

    context 'field validation error' do
      before(:each) do
        @invalid_movie_attributes = {
          name: nil,
          code: 'hello',
          director: 1,
          open_year:'hey you',
          production_year: 'bye bye'
        }
        post "/movies",
             params: { movie: @invalid_movie_attributes }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on which field was the problem' do
        json_response[:errors].each do |error| 
          expect(error[:source][:pointer]).to match(/^\/data\/attributes\//)
          expect(error[:title]).to match(/^Invalid Movie$/)
        end
      end

      it { expect(response).to have_http_status(422) }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @movie = FactoryBot.create :movie
    end

    context 'when is successfully updated' do
      before(:each) do
        patch "/movies/#{@movie.id}",
              params: { movie: { name: 'Updated name', code: 'Updated code' } }
      end

      it 'renders the json for the updated movie' do
        movie_response = json_response[:data]

        expect(movie_response).not_to be_empty
        expect(movie_response[:id]).to eql @movie.id.to_s
        expect(movie_response[:attributes][:name]).to eql 'Updated name'
        expect(movie_response[:attributes][:code]).to eql 'Updated code'
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'cannot find movie record to update' do
      before(:each) do
        patch "/movies/100",
              params: { moive: { name: 'Updated name' } }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        json_response[:errors].each do |error| 
          expect(error[:title]).to match(/^Movie not found$/)
          expect(error[:detail]).to match(/^Movie not found$/)
        end
      end
    end

    context 'field validation error' do
      before(:each) do
        patch "/movies/#{@movie.id}",
              params: { movie: { name: nil } }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on which field was the problem' do
        json_response[:errors].each do |error| 
          expect(error[:source][:pointer]).to match(/^\/data\/attributes\//)
          expect(error[:title]).to match(/^Invalid Movie$/)
        end
      end

      it { expect(response).to have_http_status(422) }
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
