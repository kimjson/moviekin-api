# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/request_helpers'

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

      it 'returns the question' do
        question_response = json_response[:data]
        expect(question_response).not_to be_empty
        expect(question_response[:id]).to eql @question.id.to_s
        expect(question_response[:attributes][:title]).to eql @question.title
        expect(question_response[:attributes][:content]).to(
          eql @question.content
        )
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
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

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        json_response[:errors].each do |error|
          expect(error[:title]).to match(/^Question not found$/)
          expect(error[:detail]).to match(/^Question not found$/)
        end
      end
    end
  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryBot.create :question }
      get '/questions'
    end

    it 'returns 4 records from the database' do
      questions_response = json_response[:data]
      expect(questions_response.size).to eq(4)
    end

    it { expect(response).to have_http_status(200) }
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

      it 'renders the json representation for the movie record just created' do
        question_response = json_response[:data]
        expect(question_response[:attributes][:title]).to(
          eql @question_attributes[:title]
        )
        expect(question_response[:attributes][:content]).to(
          eql @question_attributes[:content]
        )
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
        movie = FactoryBot.create :movie
        @invalid_question_attributes = { content: nil, title: nil }
        post "/movies/#{movie.id}/questions", params: {
          data: {
            type: 'question',
            attributes: @invalid_question_attributes
          }
        }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on which field was the problem' do
        json_response[:errors].each do |error|
          expect(error[:source][:pointer]).to match(/^\/data\/attributes\//)
          expect(error[:title]).to match(/^Invalid Question$/)
        end
      end

      it { expect(response).to have_http_status(422) }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @question = FactoryBot.create :question
    end

    context 'when is successfully updated' do
      before(:each) do
        patch "/questions/#{@question.id}", params: {
          data: {
            type: 'question',
            attributes: {
              title: 'Updated title',
              content: 'Updated content'
            }
          }
        }
      end

      it 'renders the json for the updated question' do
        question_response = json_response[:data]
        expect(question_response[:attributes][:content]).to(
          eql 'Updated content'
        )
        expect(question_response[:attributes][:title]).to eql 'Updated title'
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'cannot find question record to update' do
      before(:each) do
        patch '/questions/100', params: {
          data: {
            type: 'question',
            attributes: {
              content: 'Updated content'
            }
          }
        }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        json_response[:errors].each do |error|
          expect(error[:title]).to match(/^Question not found$/)
          expect(error[:detail]).to match(/^Question not found$/)
        end
      end
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

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on which field was the problem' do
        json_response[:errors].each do |error|
          expect(error[:source][:pointer]).to match(/^\/data\/attributes\//)
          expect(error[:title]).to match(/^Invalid Question$/)
        end
      end

      it { expect(response).to have_http_status(422) }
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
