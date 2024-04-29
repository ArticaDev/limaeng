module Api
  module V1
    class ItemsController < ApiController
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
