# frozen_string_literal: true

require 'api_constraints'
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Api definition
  namespace :api, defaults: { format: :json }, path: '/' do
    # We are going to list our resources here
    scope module: :v1,
          constraints: ApiConstraints.new(
            version: 1,
            default: true
          ) do
      # We are going to list our resources here
      resources :movies, only: %i[show index create update destroy] do
        resources :questions, only: %i[create]
      end
      resources :questions, only: %i[show index update destroy] do
        resources :answers, only: %i[create]
      end
      resources :answers, only: %i[show index update destroy]
      get '/swagger',
          to: redirect('/assets/swagger-ui-dist/index.html?url=/swagger.json')
    end
  end
end
