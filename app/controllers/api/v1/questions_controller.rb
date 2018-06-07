# frozen_string_literal: true

module Api
  module V1
    # CRUD controller for question model.
    class QuestionsController < ApplicationController
      @serializer = QuestionSerializer

      # TODO: embed answer object.
      def show
        question_response data: Question.find(params[:id])
      end

      def index
        question_response data: Question.all
      end

      def create
        question = Movie.find(params[:movie_id])
                        .questions
                        .create!(question_params)
        question_response data: question, status: 201, location: [:api, question]
      end

      def update
        question = Question.find(params[:id])
        question.update!(question_params)
        question_response data: question, status: 200, location: [:api, question]
      end

      def destroy
        Question.find(params[:id]).destroy!
        head 204
      end

      private

      def question_params
        params.require(:question).permit(:title, :content)
      end

      def question_response(args)
        serialized_args = args.clone
        serialized_args[:json] = QuestionSerializer.new(args[:data])
        render serialized_args
      end
    end
  end
end
