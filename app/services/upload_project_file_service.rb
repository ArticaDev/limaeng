# frozen_string_literal: true

class UploadProjectFileService 
    def initialize(project, file, file_name)
      @project = project
      @file = file
      @file_name = file_name
    end
  
    def call
      s3_object_key = file_key
      s3_service.store_file(file_key, @file)
      @project.documents.create!(
        file_key: s3_object_key, 
        file_type: file_type, 
        name: file_name_without_extension
      )
    end

    private

    def file_name_without_extension
      @file_name.split('.').first
    end

    def file_type
      @file_name.split('.').last
    end

    def s3_service
      Amazon::AwsS3Service.new 
    end

    def file_key
      timestamp = Time.now.to_i
      "#{timestamp}_#{@file_name}"
    end
end