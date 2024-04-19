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
        checklist = Checklist.create!(name: params[:name], user_id: user.id)
        render json: checklist
      end


      def checklists
        id = params[:id]
        checklist = Checklist.where(user_id: id)
        render json: checklist
      end

      def items(categories)
        items = []
        categories.each do |category|
          items << Item.where(category_id: category.id)
        end
        return items
      end

      def checklist_body(categories, items)
        checklist_body = []
        count = 0
        categories.each do |x|
          checklist_body << x
          items.each do |column|
            column.each do |item|
              if x.id.to_s == item.category_id.to_s
                checklist_body << item
              end
            end
          end
          count += 1
        end
        return checklist_body
      end

      def checklist
        id = params[:id]
        checklist = Checklist.find(id)
        categories = Category.where(checklists_id: id)
        render json: checklist_body(categories, items(categories))
        # render json: checklist = { :"Nome" => checklist.name, :"Categoria" =>categories[0], :"Items" => items}
      end

      def delete_checklist
        @id = params[:id]
        checklist = Checklist.where(_id: @id)
        checklist.destroy
        render json: "Checklist deletada"
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
