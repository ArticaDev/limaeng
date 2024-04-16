module Api
  module V1
    class CategoriesController < ApiController

      def index
        @categories = Category.all
        render json: @categories
      end

      def create
        @categories = Category.create!(user_params)
        render json: @categories, status: :createddo
      end
    end
  end
end
