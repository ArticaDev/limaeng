module Api
  module V1
    class CategoriesController < ApiController

      def index
        @categories = CategoryType.all
        render json: @categories
      end

      def create
        @categories = CategoryType.create!(name: params[:name])
        render json: @categories
      end

      def destroy
        @categories = CategoryType.where(id: params[:id])
        @categories.destroy
        render json: "Categoria Deletada"
      end

      def update
        id = params[:id]
        @categories = CategoryType.where(id: id)
        @categories.where(name: params[:name])
        render json: @categories
      end
    end
  end
end
