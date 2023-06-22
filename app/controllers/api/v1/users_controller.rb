# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: %i[projects show upload_profile_picture]

      def show 
        render json: user_data
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
          filename,
        ).call

        file.close
        file.unlink

        render json: user_data, status: :ok
      end

      def user_data 
        profile_picture = @user.profile_picture_url
        user_data = {
          **@user.attributes.as_json,
          profile_picture:
        }
      end

      def create
        @user = User.create!(user_params)
        render json: @user, status: :created
      end

      def projects
        render json: @user.projects
      end

      private

      def user_params
        params.permit(:name, :email, :birth_date, :phone_number)
      end

      def set_user
        @user = User.find_by(email: params[:email])
      end
    end
  end
end
