# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: %i[projects show upload_profile_picture update destroy]

      def index
        @users = User.all
        render json: @users
      end

      def show
        render json: user_data
      end

      def create
        @user = User.create!(user_params)
        render json: @user, status: :created
      end


      def create_checklist
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
        render json: "Checklist Criada"
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
        a = []
        categories.each do |category|
          category.items.each do |i|
            item_count = 0
            item = items_type.where(id: i.item_type_id)
            i.name = item[item_count].name
            item_count += 1
          end

          categories_body << category
          name = category_type.where(id: category.category_type_id)
          categories_body[count][:name] = name[0].name
          count += 1
        end
        render json: categories_body
      end

      def delete_checklist
        @id = params[:id]
        checklist = Checklist.where(_id: @id)
        checklist.destroy
        render json: "Checklist deletada"
      end

      def item
        id = params[:id]
        @item = Item.find(id)
        if params[:status] == "done" || params[:status] == "not done" || params[:status] == "partially done"
          @item.update!(status: params[:status])
        end
        render json: @item
      end


      def update
        new_email = params[:new_email]
        update_project_relationships(new_email) if new_email != @user.email
        @user.update!({ **user_params, email: new_email })
        render json: @user, status: :ok
      end

      def upload_profile_picture
        decoded_file = Base64.decode64(params[:file_content])
        file_ext = params[:file_type]
        filename = "#{@user.name}_profile_picture.#{file_ext}"

        file = Tempfile.new("temp_#{filename}")
        file.binmode
        file.write(decoded_file)
        file.rewind

        UploadProfilePictureService.new(
          @user,
          file,
          filename
        ).call

        file.close
        file.unlink

        render json: user_data, status: :ok
      end

      def user_data
        profile_picture = @user.profile_picture_url
        {
          **@user.attributes.as_json,
          profile_picture:
        }
      end

      def projects
        render json: @user.projects
      end

      def destroy
        @user.projects.each do |project|
          Project.find(project[:id]).destroy
        end
        @user.team_members.destroy_all

        @user.destroy

        render json: @user, status: :ok
      end

      private

      def update_project_relationships(email)
        @user.team_members.each do |team_member|
          team_member.update!(user_email: email)
        end
      end

      def user_params
        params.permit(:name, :email, :birth_date, :phone_number)
      end

      def set_user
        @user = User.find_by(email: params[:email])
      end
    end
  end
end
