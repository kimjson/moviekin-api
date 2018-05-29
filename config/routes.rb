require 'api_constraints'
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Api definition
  namespace :api, defaults: { format: :json }, path: '/' do
    # We are going to list our resources here
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our resources here
      resources :questions, :only => [:show, :index, :create, :update, :destroy] do
        resources :answers, :only => [:create]
      end
      resources :movies, :only => [:show, :index, :create, :update, :destroy]
      resources :answers, :only => [:show, :index, :update, :destroy]
      resources :apidocs, :only => [:index]
      get '/docs', to: redirect('/assets/swagger-ui-dist/index.html?url=/apidocs')
    end
  end
end
