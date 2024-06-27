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
          group = Group.create!(checklist: checklist.id, group_type_id: groups.id)
          categories_type.where(group_type: groups.id).each do |category_type|
            category = Category.create!(group_id: group.id, category_type_id: category_type.id)
            items_type.where(category_type_id: category_type.id.to_s).each do |item|
              item = Item.create!(category_id: category.id, item_type_id: item.id, status: "not done")
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
        checklist = Checklist.find(id)
        groups = checklist.groups
        body = groups.map do |group|
          categories = group.categories.map do |category|
            items = category.items.map{|i| i.attributes.merge(name: i.name)}
            {
              name: category.name,
              items: items
            }
          end
          {
            name: group.name,
            categories: categories
          }
        end
        checklist_data = {
          name: checklist.name,
          building: checklist.building_type,
          groups: body
        }
        render json: checklist_data
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
