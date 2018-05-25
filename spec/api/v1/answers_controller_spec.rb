require 'rails_helper'
require_relative '../../support/request_helpers'

RSpec.configure do |c|
  c.include Request::JsonHelpers
end

RSpec.describe Api::V1::AnswersController, type: :request do
  describe "GET #show" do
    before(:each) do
      @answer = FactoryBot.create :answer
      get "/answers/#{@answer.id}"
    end

    it "returns the information about the record" do
      answer_response = json_response
      expect(answer_response[:content]).to eql @answer.content
    end

    it { expect(response).to have_http_status(200) }
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryBot.create :answer }
      get "/answers"
    end

    it "returns 4 records from the database" do
      answers_response = json_response
      expect(answers_response.size).to eq(4)
    end

    it { expect(response).to have_http_status(200) }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        question = FactoryBot.create :question
        @answer_attributes = FactoryBot.attributes_for :answer
        post "/questions/#{question.id}/answers", params: { answer: @answer_attributes }
      end

      it "renders the json representation for the answer record just created" do
        answer_response = json_response
        expect(answer_response[:content]).to eql @answer_attributes[:content]
      end

      it { expect(response).to have_http_status(201) }
    end

    context "when is not created" do
      before(:each) do
        question = FactoryBot.create :question
        @invalid_answer_attributes = { content: nil }
        post "/questions/#{question.id}/answers", params: { answer: @invalid_answer_attributes }
      end

      it "renders an errors json" do
        answer_response = json_response
        expect(answer_response).to have_key(:errors)
      end

      it "renders the json errors on why the answer could not be created" do
        answer_response = json_response
        Rails.logger.debug "answer_response: #{answer_response}"
        expect(answer_response[:errors][:content]).to include "can't be blank"
      end

      it { expect(response).to have_http_status(422) }
    end
  end
end
