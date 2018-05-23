require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :request do
  describe "GET #show" do
    before(:each) do
      @answer = FactoryBot.create :answer
      get "/answers/#{@answer.id}"
    end

    it "returns the information about the record" do
      answer_response = JSON.parse(response.body)
      expect(answer_response["content"]).to eql @answer.content
    end

    it { expect(response).to have_http_status(200) }
  end
  describe "GET #index" do
    before(:each) do
      @answers = []
      (1...4).each do |n|
        @answers << FactoryBot.create :answer
      end
      get "/answers"
    end

    it "returns 4 records from the database" do
      answers_response = JSON.parse(response.body)
      expect(answers_response[:answers]).to have(4).items
    end

    it { expect(response).to have_http_status(200) }
  end
end
