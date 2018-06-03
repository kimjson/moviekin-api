class Api::V1::AnswersController < ApplicationController

  def show
    render json: AnswerSerializer.new(Answer.find(params[:id]))
  end

  def index
    render json: AnswerSerializer.new(Answer.all)
  end

  def create
    answer = Question.find(params[:question_id]).answers.create!(answer_params)
    render json: AnswerSerializer.new(answer), status: 201, location: [:api, answer]
  end

  def update
    answer = Answer.find(params[:id])
    answer.update!(answer_params)
    render json: AnswerSerializer.new(answer), status: 200, location: [:api, answer]
  end

  def destroy
    Answer.find(params[:id]).destroy!
    head 204
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end

end
