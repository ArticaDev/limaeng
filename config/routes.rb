# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resource :projects do
        post '/add_member', to: 'projects#add_member'
        get '/members/:id', to: 'projects#project_members'
        post '/remove_member', to: 'projects#remove_member'
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
        post '/all_percentage_per_month', to: 'stages#all_percentage_per_month'
        post '/progression', to: 'stages#stages_progression'
      end

      resource :budgets do
        get '/:id', to: 'budgets#show'
        post '/update/:id', to: 'budgets#update'
      end

      resource :users do
        post '/get_projects', to: 'users#projects'
        post '/', to: 'users#create'
      end

      resource :documents do
        post '/upload/:id', to: 'documents#upload'
        post '/upload/json/:id', to: 'documents#upload_as_json'
        get '/:id', to: 'documents#show'
      end
    end
  end

  root to: 'home#index'
end
