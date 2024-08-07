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
          if group_type.name == "Deprecated"
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
        body = {}
        checklist = Checklist.find(id)
        if checklist.building_type.nil?
          body = old_checklist(checklist)
        else
          body = new_checklist(checklist)
        end
        render json: body
      end

      def destroy
        id = params[:id]
        checklist = Checklist.find(id)
        checklist.destroy
        render json: "Checklist deleted"
      end

      private def old_checklist(checklist)
        categories = Category.where(checklist_id: checklist.id)
        t = []
        if categories[0].group.nil?
            if GroupType.find_by(name: "Deprecated").nil?
              GroupType.create!(name: "Deprecated")
            end
          group_type_id =  GroupType.find_by(name: "Deprecated").id
          Group.create(checklist_id: checklist.id, group_type_id: group_type_id)
        end
        group = Group.find_by(checklist_id: checklist.id)
        group_type_id =  GroupType.find_by(name: "Deprecated").id
        body = categories.map do |category|
          category_type = category.category_type.group_type_id
          if category.group.nil?
            if category_type.nil?
              category.category_type.update!(group_type_id: group_type_id)
            end
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
        return checklist_data
      end

      private def new_checklist(checklist)
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
            name: group.name == "Área Interna" ? "Interno" : 'Externo',
            categories: categories
          }
        end
        checklist_data = {
          name: checklist.name,
          building: checklist.building_type,
          groups: body
        }
        return checklist_data
      end

    end
  end
end
