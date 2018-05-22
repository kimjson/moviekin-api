require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :request do
  describe "GET #show" do
    before(:each) do
      @answer = FactoryBot.create :answer
      get "/answers/#{@answer.id}"
    end

    it "returns the information about an answer" do
      answer_response = JSON.parse(response.body)
      expect(answer_response["content"]).to eql @answer.content
    end

    it { expect(response).to have_http_status(200) }
  end
end
