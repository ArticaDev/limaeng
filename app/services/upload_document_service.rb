# frozen_string_literal: true

class UploadDocumentService
    def initialize(file, original_filename)
      @file = file
      @original_filename = original_filename
    end
  
    def call
      file_name = file_key
      s3_service.store_file(file_name, @file, true)
      Amazon::AwsS3Service.new.public_url(file_name)
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
  