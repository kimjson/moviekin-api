# frozen_string_literal: true

module Api
  module V1
    # CRUD controller for answer model.
    class AnswersController < ApplicationController
      def show
        answer_response data: Answer.find(params[:id])
      end

      def index
        answer_response data: Answer.all
      end

      def create
        answer = Question.find(params[:question_id])
                        .answers
                        .create!(answer_params)
        answer_response data: answer, status: 201, location: [:api, answer]
      end

      def update
        answer = Answer.find(params[:id])
        answer.update!(answer_params)
        answer_response data: answer, status: 200, location: [:api, answer]
      end

      def destroy
        Answer.find(params[:id]).destroy!
        head 204
      end

      private

      def answer_params
        params.require(:answer).permit(:content)
      end

      def answer_response(args)
        serialized_args = args.clone
        serialized_args[:json] = AnswerSerializer.new(args[:data])
        render serialized_args
      end
    end
  end
end
