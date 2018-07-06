# frozen_string_literal: true

module Api
  module V1
    # CRUD controller for question model.
    class QuestionsController < ApplicationController
      def setup
        @serializer = QuestionSerializer
      end

      def show
        json_response data: Question.find(params[:id])
      end

      def index
        json_response data: Question.all
      end

      def create
        question = Movie.find(params[:movie_id])
                        .questions
                        .create!(question_params)
        json_response data: question, status: 201, location: [:api, question]
      end

      def update
        question = Question.find(params[:id])
        question.update!(question_params)
        json_response data: question, status: 200, location: [:api, question]
      end

      def destroy
        Question.find(params[:id]).destroy!
        head 204
      end

      private

      def question_params
        question_attributes = %i[title content]
        params.require(:data)
              .permit(:type, :relationships, attributes: question_attributes)
              .require(:attributes).permit(*question_attributes)
      end
    end
  end
end
