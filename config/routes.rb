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
        post '/', to: 'projects#create'
        get '/:id', to: 'projects#show'
        put '/:id', to: 'projects#update'
        delete '/:id', to: 'projects#destroy'
      end

      resources :states, only: %i[index create]

      resource :stages do
        get '/types', to: 'stages#stage_types'
        get '/steps/:id', to: 'stages#stage_steps'
        post '/update_steps', to: 'stages#update_stage_steps'
        post '/update', to: 'stages#update_stage'
        post '/month', to: 'stages#month'
        post '/all_percentage_per_month', to: 'stages#all_percentage_per_month'
        post '/progression', to: 'stages#stages_progression'
        post '/', to: 'stages#stage'
      end

      resource :budgets do
        get '/:id', to: 'budgets#show'
        post '/update/:id', to: 'budgets#update'
      end

      resource :users do
        post '/get_user_data', to: 'users#show'
        post '/get_projects', to: 'users#projects'
        post '/update', to: 'users#update'
        post '/', to: 'users#create'
        post '/upload-profile-picture', to: 'users#upload_profile_picture'
      end

      resource :documents do
        post '/upload/:id', to: 'documents#upload'
        post '/upload/json/:id', to: 'documents#upload_as_json'
        post '/upload_generic', to: 'documents#upload_generic'
        get '/:id', to: 'documents#show'
      end
    end
  end

  root to: 'home#index'
end
