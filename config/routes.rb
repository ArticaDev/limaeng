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
      end


    end
  end



  root to: 'home#index'
end
