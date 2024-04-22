# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'delete_account', to: 'users#delete_account'

  namespace :api do
    namespace :v1 do
      resource :projects do
        post '/add_member', to: 'projects#add_member'
        get '/members/:id', to: 'projects#project_members'
        post '/remove_member', to: 'projects#remove_member'
        post '/update_member', to: 'projects#update_member'
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
        post '/create_custom_stage', to: 'stages#create_custom_stage'
        post '/', to: 'stages#stage'
      end

      resource :budgets do
        get '/:id', to: 'budgets#show'
        post '/update/:id', to: 'budgets#update'
        post '/simulate', to: 'budgets#simulate'
      end

      resource :users do
        get '/', to: 'users#index'
        get '/checklists/:id', to: 'users#checklists'
        get '/checklist/:id', to: 'users#checklist'
        delete '/', to: 'users#destroy'
        delete '/delete_checklist/:id', to: 'users#delete_checklist'
        post 'item/:id', to: 'users#item'
        post '/get_user_data', to: 'users#show'
        post '/get_projects', to: 'users#projects'
        post '/update', to: 'users#update'
        post '/', to: 'users#create'
        post '/upload-profile-picture', to: 'users#upload_profile_picture'
        post '/create_checklist', to: 'users#create_checklist'
      end

      resource :documents do
        post '/upload/:id', to: 'documents#upload'
        post '/upload/json/:id', to: 'documents#upload_as_json'
        post '/update_file_name/:id', to: 'documents#update_file_name'
        post '/upload_generic', to: 'documents#upload_generic'
        post '/delete_file', to: 'documents#delete_file'
        get '/:id', to: 'documents#show'
      end

      resource :checklists do
        get '/', to: 'checklists#index'
      end

      resource :categories do
        get '/', to: 'categories#index'
        post '/', to: 'categories#create'
      end

      resource :items do
        get '/', to: 'items#index'
      end

      resource :status do
        get '/', to: 'status#index'
      end
    end
  end

  root to: redirect('/admin/state')
end
