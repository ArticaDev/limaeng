# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: %i[projects]

      def create
        @user = User.create!(user_params)
        render json: @user, status: :created
      end

      def projects
        render json: @user.projects
      end

      private

      def user_params
        params.permit(:name, :email, :birth_date, :phone_number)
      end

      def set_user
        @user = User.find_by(email: params[:email])
      end
    end
  end
end
