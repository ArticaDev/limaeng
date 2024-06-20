module Api
  module V1
    class ChecklistsController < ApiController

      def create
        user = User.find(params[:user_id])
        checklist = Checklist.create!(name: params[:name], user_id: params[:user_id], building_type: params[:building_type])
        groups_type = GroupType.all
        categories_type = CategoryType.all
        items_type = ItemType.all
        groups_type.each do |groups|
          if checklist.building_type == "Apartamento" && groups.name == "Externo"
            next
          end
          group = Group.create!(checklist: checklist.id, group_type: groups.name)
          categories_type.where(group_type: groups.id).each do |category_type|
            category = Category.create!(group_id: group.id, category_type_id: category_type.id, name: category_type.name)
            items_type.where(category_type_id: category_type.id.to_s).each do |item|
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

        render json: checklist_body
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
