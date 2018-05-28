class Api::V1::QuestionsController < ApplicationController

  # TODO embed answer object.
  def show
    render json: Question.find(params[:id])
  end

  def index
    render json: Question.all
  end
  
  def create
    question = Question.create!(question_params)
    render json: question, status: 201, location: [:api, question]
  end

  def update
    question = Question.find(params[:id])
    question.update!(question_params)
    render json: question, status: 200, location: [:api, question]
  end

  def destroy
    Question.find(params[:id]).destroy!
    head 204
  end

  private

  def question_params
    params.require(:question).permit(:title, :content)
  end
  
end
