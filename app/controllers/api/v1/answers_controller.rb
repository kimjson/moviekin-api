# frozen_string_literal: true

module Api
  module V1
    # CRUD controller for answer model.
    class AnswersController < ApplicationController
      def setup
        @serializer = AnswerSerializer
      end

      def show
        json_response data: Answer.find(params[:id])
      end

      def index
        json_response data: Answer.all
      end

      def create
        answer = Question.find(params[:question_id])
                         .answers
                         .create!(answer_params)
        json_response data: answer, status: 201, location: [:api, answer]
      end

      def update
        answer = Answer.find(params[:id])
        answer.update!(answer_params)
        json_response data: answer, status: 200, location: [:api, answer]
      end

      def destroy
        Answer.find(params[:id]).destroy!
        head 204
      end

      private

      def answer_params
        answer_attributes = %i[content]
        params.require(:data)
              .permit(:type, :relationships, attributes: answer_attributes)
              .require(:attributes)
              .permit(*answer_attributes)
      end
    end
  end
end
