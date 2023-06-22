# frozen_string_literal: true

class UploadProfilePictureService
  def initialize(user, file, filename)
    @user = user
    @file = file
    @filename = filename
  end

  def call
    s3_service.store_file(@filename, @file)
    @user.update!(profile_picture_name: @filename)
  end

  private

  def s3_service
    Amazon::AwsS3Service.new
  end
end
