class Api::V1::AnswersController < ApplicationController

  def show
    render json: Answer.find(params[:id])
  end
end
