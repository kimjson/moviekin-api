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

    context 'when the record does not exist' do
      before(:each) do
        get '/questions/100'
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Question/)
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
        post "/movies/#{movie.id}/questions",
             params: { question: @question_attributes }
      end

      it 'renders the json representation for the answer record just created' do
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

    # TODO: add more test case (invalid field case)
    context 'when is not created' do
      before(:each) do
        movie = FactoryBot.create :movie
        @invalid_question_attributes = { content: nil }
        post "/movies/#{movie.id}/questions",
             params: { question: @invalid_question_attributes }
      end

      it 'renders an errors json' do
        question_response = json_response
        expect(question_response).to have_key(:message)
      end

      it 'renders the json errors on why the question could not be created' do
        question_response = json_response
        expect(question_response[:message]).to include "can't be blank"
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
        patch "/questions/#{@question.id}",
              params: {
                question: {
                  title: 'Updated title',
                  content: 'Updated content'
                }
              }
      end

      it 'renders the json for the updated answer' do
        question_response = json_response[:data]
        expect(question_response[:attributes][:content]).to(
          eql 'Updated content'
        )
        expect(question_response[:attributes][:title]).to eql 'Updated title'
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'when is not updated' do
      before(:each) do
        patch "/questions/#{@question.id}",
              params: { question: { content: nil } }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:message)
      end

      it 'renders the error message on why the answer could not be updated' do
        expect(json_response[:message]).to include "can't be blank"
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
