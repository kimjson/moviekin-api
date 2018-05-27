class Api::V1::AnswersController < ApplicationController

  def show
    render json: Answer.find(params[:id])
  end

  def index
    render json: Answer.all
  end

  def create
    answer = Question.find(params[:question_id]).answers.create!(answer_params)
    render json: answer, status: 201, location: [:api, answer]
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end

end
