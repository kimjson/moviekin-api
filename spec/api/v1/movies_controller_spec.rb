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

      # TODO: test release_date equality
      include_examples 'response attributes correct v2' do
        let(:target_attributes) do
          @movie.as_json.symbolize_keys.extract!(
            :title,
            :kmdb_seq,
            :director,
            :production_year
          )
        end
      end

      include_examples 'returns record with correct id' do
        let(:target_id) { @movie.id.to_s }
      end
      
      it { expect(response).to have_http_status(200) }
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

      # TODO: test release_date equality
      include_examples 'response attributes correct v2' do
        let(:target_attributes) { @movie_attributes.except(:release_date) }
      end

      it { expect(response).to have_http_status(201) }
    end

    context 'field validation error' do
      before(:each) do
        @invalid_movie_attributes = {
          title: nil,
          kmdb_seq: 'hello',
          director: 1,
          release_date: 'hey you',
          production_year: 'bye bye',
          nation: nil
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
      @new_movie_attributes = FactoryBot.attributes_for :movie
    end

    context 'when is successfully updated' do
      before(:each) do
        patch "/movies/#{@movie.id}", params: {
          data: {
            type: 'movie',
            attributes: @new_movie_attributes
          }
        }
      end

      it 'ID did not change after update' do
        expect(json_response[:data][:id]).to eql @movie.id.to_s
      end

      include_examples 'response attributes correct v2' do
        let(:target_attributes) { @new_movie_attributes.except(:release_date) }
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'cannot find movie record to update' do
      before(:each) do
        patch '/movies/100', params: {
          data: {
            type: 'movie',
            attributes: @new_movie_attributes
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
            attributes: { title: nil }
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
