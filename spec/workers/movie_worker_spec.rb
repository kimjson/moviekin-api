# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovieWorker do
  # describe 'Every movie object fetched stored to db' do
  #   before(:all) do
  #     MovieWorker.new.perform
      
  #   end
  # end

  # TODO: duplicate test. duplicate should skip.
  # describe 'After some of the movies failed to be stored retry to make all succeed'
  
  # describe 'GET #show' do
  #   context 'when the record exists' do
  #     before(:each) do
  #       @movie = FactoryBot.create :movie
  #       3.times { FactoryBot.create :question, movie: @movie }
  #       get "/movies/#{@movie.id}"
  #     end

  #     # TODO: test release_date equality
  #     include_examples 'response attributes correct v2' do
  #       let(:target_attributes) do
  #         @movie.as_json.symbolize_keys.extract!(
  #           :title,
  #           :kmdb_docid,
  #           :director,
  #           :production_year
  #         )
  #       end
  #     end

  #     include_examples 'returns record with correct id' do
  #       let(:target_id) { @movie.id.to_s }
  #     end

  #     it { expect(response).to have_http_status(200) }
  #   end

  #   context 'when the record does not exist' do
  #     before(:each) do
  #       get '/movies/100'
  #     end

  #     include_examples 'not found', 'movie'
  #   end
  # end

end
