# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/request_helpers'

RSpec.configure do |c|
  c.include Request::JsonHelpers
end

RSpec.describe Api::V1::AnswersController, type: :request do
  describe 'GET #show' do
    context 'when the record exists' do
      before(:each) do
        @answer = FactoryBot.create :answer
        get "/answers/#{@answer.id}"
      end

      it 'returns the answer' do
        answer_response = json_response[:data]
        expect(answer_response).not_to be_empty
        expect(answer_response[:id]).to eq(@answer.id.to_s)
        expect(answer_response[:attributes][:content]).to eql @answer.content
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before(:each) do
        get '/answers/100'
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Answer/)
      end
    end
  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryBot.create :answer }
      get '/answers'
    end

    it 'returns 4 records from the database' do
      answers_response = json_response[:data]
      expect(answers_response.size).to eq(4)
    end

    it { expect(response).to have_http_status(200) }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        question = FactoryBot.create :question
        @answer_attributes = FactoryBot.attributes_for :answer
        post "/questions/#{question.id}/answers",
             params: { answer: @answer_attributes }
      end

      it 'renders the json representation for the answer record just created' do
        answer_response = json_response[:data]
        expect(answer_response[:attributes][:content]).to(
          eql @answer_attributes[:content]
        )
      end

      it { expect(response).to have_http_status(201) }
    end

    context 'when is not created' do
      before(:each) do
        question = FactoryBot.create :question
        @invalid_answer_attributes = { content: nil }
        post "/questions/#{question.id}/answers",
             params: { answer: @invalid_answer_attributes }
      end

      it 'renders an errors json' do
        answer_response = json_response
        expect(answer_response).to have_key(:message)
      end

      it 'renders the json errors on why the answer could not be created' do
        answer_response = json_response
        expect(answer_response[:message]).to include "can't be blank"
      end

      it { expect(response).to have_http_status(422) }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @answer = FactoryBot.create :answer
    end

    context 'when is successfully updated' do
      before(:each) do
        patch "/answers/#{@answer.id}",
              params: { answer: { content: 'Updated content' } }
      end

      it 'renders the json for the updated answer' do
        answer_response = json_response[:data]
        expect(answer_response[:attributes][:content]).to eql 'Updated content'
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'when is not updated' do
      before(:each) do
        patch "/answers/#{@answer.id}",
              params: { answer: { content: nil } }
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
      @answer = FactoryBot.create :answer
      delete "/answers/#{@answer.id}"
    end

    it { expect(response).to have_http_status(204) }
  end
end
