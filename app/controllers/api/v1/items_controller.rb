module Api
  module V1
    class ItemsController < ApiController
      def  index
        @items = ItemType.all
        render json: @items
      end

      def create
        category_type = CategoryType.find(params[:category_type_id])
        checklist = ItemType.create!(name: params[:name], category_type_id: category_type)
        render json: checklist
      end

      def destroy
        @items = ItemType.where(id: params[:id])
        @items.destroy
        render json: "Item Type deleted"

        def item
          id = params[:id]
          @item = Item.find(id)
          if params[:status] == "done" || params[:status] == "not done" || params[:status] == "partially done"
            @item.update!(status: params[:status])
          end
          render json: @item
        end

      end
    end
  end
end
