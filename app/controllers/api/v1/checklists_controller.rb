module Api
  module V1
    class ChecklistsController < ApiController

      def create
        user = User.find(params[:user_id])
        checklist = Checklist.create!(name: params[:name], user_id: params[:user_id])
        categories_type = CategoryType.all
        items_type = ItemType.all
        categories_type.each do |category_type|
          category = Category.create!(checklist_id: checklist.id, category_type_id: category_type.id)

          item_array = items_type.where(category_type_id: category_type.id.to_s)
          item_array.each do |item|
            item = Item.create!(category_id: category.id, item_type_id: item.id.to_s, status: "not done")
          end
        end
        render json: "Checklist created"
      end


      def checklists
        id = params[:id]
        checklist = Checklist.where(user_id: id)
        render json: checklist
      end

      def checklist
        id = params[:id]
        checklist = Checklist.find(id)
        categories = Category.where(checklist_id: id)
        category_type = CategoryType.all
        items_type = ItemType.all
        items = Item.all
        count = 0
        categories_body = []
        categories.each do |category|
          category.items.each do |i|
            item = items_type.where(id: i.item_type_id)
            i.name = item.name
          end

          categories_body << category
          name = category_type.where(id: category.category_type_id)
          categories_body[count][:name] = name[0].name
          count += 1
        end
        render json: categories_body
      end

      def destroy
        id = params[:id]
        checklist = Checklist.find(id)
        checklist.destroy
        render json: "Checklist deleted"
      end
    end
  end
end
