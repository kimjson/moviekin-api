# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/request_helpers'
require 'shared_examples'

RSpec.configure do |c|
  c.include Request::JsonHelpers
end

RSpec.describe Api::V1::QuestionsController, type: :request do
  describe 'GET #show' do
    context 'when the record exists' do
      before(:each) do
        @question = FactoryBot.create :question
        get "/questions/#{@question.id}"
      end

      include_examples 'response attributes correct v2' do
        let(:target_attributes) do
          @question.as_json.symbolize_keys.extract!(:title, :content)
        end
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'requests existing question record including its answers' do
      before(:each) do
        @question = FactoryBot.create :question
        3.times { FactoryBot.create :answer, question: @question }
        get "/questions/#{@question.id}?include=answers"
      end

      it 'has 3 answers in it' do
        included_answers = json_response[:included]
        expect(included_answers.size).to eq(3)
      end
    end

    context 'when the record does not exist' do
      before(:each) do
        get '/questions/100'
      end

      include_examples 'not found', 'question'
    end
  end

  describe 'GET #index' do
    include_examples(
      'returns 4 records from the database',
      'question',
    )
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        movie = FactoryBot.create :movie
        @question_attributes = FactoryBot.attributes_for :question
        post "/movies/#{movie.id}/questions", params: {
          data: {
            type: 'question',
            attributes: @question_attributes
          }
        }
      end

      include_examples 'response attributes correct v2' do
        let(:target_attributes) { @question_attributes }
      end

      it { expect(response).to have_http_status(201) }
    end

    context 'movie not found' do
      before(:each) do
        @question_attributes = FactoryBot.attributes_for :question
        post '/movies/100/questions', params: {
          data: {
            type: 'question',
            attributes: @question_attributes
          }
        }
      end

      include_examples 'not found', 'movie'
    end

    context 'field validation error' do
      before(:each) do
        movie = FactoryBot.create :movie
        @invalid_question_attributes = { content: nil, title: nil }
        post "/movies/#{movie.id}/questions", params: {
          data: {
            type: 'question',
            attributes: @invalid_question_attributes
          }
        }
      end
      
      include_examples 'field validation error result', 'question', 'Questions'
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @question = FactoryBot.create :question
      @new_question_attributes = FactoryBot.attributes_for :question
    end

    context 'when is successfully updated' do
      before(:each) do
        patch "/questions/#{@question.id}", params: {
          data: {
            type: 'question',
            attributes: @new_question_attributes
          }
        }
      end

      it 'ID matches' do
        expect(json_response[:data][:id]).to eql @question.id.to_s
      end

      include_examples 'response attributes correct v2' do
        let(:target_attributes) { @new_question_attributes }
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'cannot find question record to update' do
      before(:each) do
        patch '/questions/100', params: {
          data: {
            type: 'question',
            attributes: @new_question_attributes
          }
        }
      end

      include_examples 'not found', 'question'
    end

    context 'field validation error' do
      before(:each) do
        patch "/questions/#{@question.id}", params: {
          data: {
            type: 'question',
            attributes: {
              content: nil
            }
          }
        }
      end

      include_examples 'field validation error result', 'question', 'Questions'
    end
  end
  describe 'DELETE #destroy' do
    before(:each) do
      @question = FactoryBot.create :question
      delete "/questions/#{@question.id}"
    end

    it { expect(response).to have_http_status(204) }
  end
end
