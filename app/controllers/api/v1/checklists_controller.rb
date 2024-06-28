module Api
  module V1
    class ChecklistsController < ApiController

      def create
        user = User.find(params[:user_id])
        checklist = Checklist.create!(name: params[:name], user_id: params[:user_id], building_type: params[:building_type])
        super_classes = GroupType.all
        super_classes.each do |group_type|
          if checklist.building_type == "Apartamento" && group_type.name == "Externo"
            next
          end
          group = Group.create!(checklist: checklist.id, group_type_id: group_type.id)
          CategoryType.where(group_type: group_type.id).each do |category_type|
            category = Category.create!(group_id: group.id, category_type_id: category_type.id)
            ItemType.where(category_type_id: category_type.id.to_s).each do |item|
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
        cat = []
        if checklist.building_type.nil?
          categories = Category.where(checklist_id: checklist.id)
          if categories[0].group.nil?
              if GroupType.find_by(name: "Deprecated").nil?
                superclass = GroupType.create!(name: "Deprecated")
              end
            group = Group.create(checklist_id: checklist.id, group_type_id: GroupType.find_by(name: "Deprecated"))
          end
          body = categories.map do |category|
            if category.group.nil?
              category.category_type.update!(group_type_id: GroupType.find_by(name: "Deprecated"))
              category.update!(group_id: group.id)
            end
            items = category.items.map{|i| i.attributes.merge(name: i.name)}
            {
              name: category.name,
              items: items
            }
          end
          checklist_data = {
            name: checklist.name,
            building: checklist.building_type,
            categories: body
          }
          render json: checklist_data
        end
        if !checklist.building_type.nil?
          groups = checklist.groups
          body = groups.map do |group|
            categories = group.categories.map do |category|
              items = category.items.map{|i| i.attributes.merge(name: i.name)}
              {
                name: category.name,
                building: checklist.building_type,
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
