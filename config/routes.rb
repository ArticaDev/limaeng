# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resource :projects do
        get '/', to: 'projects#index'
        post '/:id', to: 'projects#create'
        get '/:id', to: 'projects#show'
        put '/:id', to: 'projects#update'
        delete '/:id', to: 'projects#destroy'
      end

      resource :stages do
        get '/types', to: 'stages#stage_types'
        post '/', to: 'stages#stage'
        post '/update', to: 'stages#update_stage'
        post '/month', to: 'stages#month'
        post '/progression', to: 'stages#stages_progression'
      end

      resource :budgets do
        get '/:id', to: 'budgets#show'
      end

      resource :users do
        post 'get_project/:email', to: 'users#project'
        post '/', to: 'users#create'
      end
    end
  end

  root to: 'home#index'
end
