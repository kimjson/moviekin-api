class Api::V1::AnswersController < ApplicationController

  def show
    render json: Answer.find(params[:id])
  end

  def index
    render json: Answer.all
  end

end
