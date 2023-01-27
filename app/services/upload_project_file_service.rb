# frozen_string_literal: true

class UploadProjectFileService 
    def initialize(project, file, original_filename, custom_filename)
      @project = project
      @file = file
      @original_filename = original_filename
      @custom_filename = custom_filename
    end
  
    def call
      s3_object_key = file_key
      s3_service.store_file(file_key, @file)
      @project.documents.create!(
        file_key: s3_object_key, 
        file_type: file_type, 
        name: @custom_filename
      )
    end

    private

    def file_type
      @original_filename.split('.').last
    end

    def s3_service
      Amazon::AwsS3Service.new 
    end

    def file_key
      timestamp = Time.now.to_i
      "#{timestamp}_#{@original_filename}"
    end
end