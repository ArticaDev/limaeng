module Api
  module V1
    class ChecklistsController < ApiController

      def create
        user = User.find(params[:user_id])
        checklist = Checklist.create!(name: params[:name], user_id: params[:user_id])
        groups_name = GroupName.all
        categories_type = CategoryType.all
        items_type = ItemType.all
        groups_name.each do |groups|
          group = Group.create!(checklist: checklist.id, group_name: groups.name)
          categories_type.each do |category_type|
            category = Category.create!(group_id: group.id, category_type_id: category_type.id, name: category_type.name)
            item_array = items_type.where(category_type_id: category_type.id.to_s)
            item_array.each do |item|
              item = Item.create!(category_id: category.id, item_type_id: item.id.to_s, name: item.name, status: "not done")
            end
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
        checklist_body = []
        checklist_id = Checklist.find(id).id
        groups = Group.where(checklist_id: checklist_id)
        groups.each do |group|
          group.category << Category.where(group_id: group.id)
          checklist_body << group
        end

        render json: checklist_body[0]
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
