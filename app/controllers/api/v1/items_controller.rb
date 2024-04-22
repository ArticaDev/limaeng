module Api
  module V1
    class ItemsController < ApiController
      def  index
        @items = ItemType.all
        render json: @items
      end

      def create
        category_type = CategoryType.find(params[:category_type_id])
        checklist = ItemType.create!(name: params[:name], category_type_id: category_type.id)
        render json: checklist
      end

      def destroy
        @items = ItemType.where(id: params[:id])
        @items.destroy
        render json: "Item Deletado"
      end
    end
  end
end
