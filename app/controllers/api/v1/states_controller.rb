# frozen_string_literal: true

module Api
    module V1
      class StatesController < ApiController

        def index
            states = State.all
            render json: states, status: :ok    
        end

        def create
            state = State.create!(state_params)
            render json: state, status: :created
        end

        private

        def state_params
            params.permit(:name, :initials)
        end
      end
    end
  end
  