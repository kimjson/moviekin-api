# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/request_helpers'
require 'shared_examples'

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

      include_examples 'response attributes correct v2' do
        let(:target_attributes) do
          @answer.as_json.symbolize_keys.extract!(:content)
        end
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'when the record does not exist' do
      before(:each) do
        get '/answers/100'
      end

      include_examples 'not found', 'answer'
    end
  end

  describe 'GET #index' do
    include_examples 'returns 4 records from the database', 'answer'
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        question = FactoryBot.create :question
        @answer_attributes = FactoryBot.attributes_for :answer
        post "/questions/#{question.id}/answers", params: {
          data: {
            type: 'answer',
            attributes: @answer_attributes
          }
        }
      end

      include_examples 'response attributes correct v2' do
        let(:target_attributes) { @answer_attributes }
      end

      it { expect(response).to have_http_status(201) }
    end

    context 'field validation error' do
      before(:each) do
        question = FactoryBot.create :question
        @invalid_answer_attributes = { content: nil }
        post "/questions/#{question.id}/answers", params: {
          data: {
            type: 'answer',
            attributes: @invalid_answer_attributes
          }
        }
      end

      include_examples 'field validation error result', 'answer'
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @answer = FactoryBot.create :answer
      @new_answer_attributes = FactoryBot.attributes_for :answer
    end

    context 'when is successfully updated' do
      before(:each) do
        patch "/answers/#{@answer.id}", params: {
          data: {
            type: 'answer',
            attributes: @new_answer_attributes
          }
        }
      end

      include_examples 'response attributes correct v2' do
        let(:target_attributes) { @new_answer_attributes }
      end

      it 'ID matches' do
        expect(json_response[:data][:id]).to eql @answer.id.to_s
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'cannot find answer record to update' do
      before(:each) do
        patch '/answers/100', params: {
          data: {
            type: 'answer',
            attributes: @new_answer_attributes
          }
        }
      end

      include_examples 'not found', 'answer'
    end

    context 'field validation error' do
      before(:each) do
        patch "/answers/#{@answer.id}", params: {
          data: {
            type: 'answer',
            attributes: { content: nil }
          }
        }
      end

      include_examples 'field validation error result', 'answer'
    end
  end
  describe 'DELETE #destroy' do
    context 'when is successfully created' do
      before(:each) do
        @answer = FactoryBot.create :answer
        delete "/answers/#{@answer.id}"
      end

      it 'returns status code 204(deleted)' do
        expect(response).to have_http_status(204)
      end
    end

    context 'cannot find answer record to delete' do
      before(:each) do
        @answer = FactoryBot.create :answer
        delete '/answers/100'
      end

      include_examples 'not found', 'answer'
    end
  end
end
