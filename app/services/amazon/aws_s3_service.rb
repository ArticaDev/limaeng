# frozen_string_literal: true

module Amazon
  class AwsS3Service
  
    def store_file(file_name, file_content)
      s3_client.put_object(
        bucket: aws_bucket,
        key: file_name,
        body: file_content
      )
    end

    def file_url(file_name)
      presigner.presigned_url(
        :get_object,
        bucket: aws_bucket,
        key: file_name
      )
    end

    private

    def s3_client
      Aws::S3::Client.new(
        region: aws_region,
        credentials: aws_credentials
      )
    end

    def presigner 
      Aws::S3::Presigner.new(
        client: s3_client
      )
    end

    def aws_credentials
      Rails.application.config.aws_credentials
    end

    def aws_region
      Rails.application.config.aws_region
    end

    def aws_bucket
      Rails.application.config.aws_bucket
    end
  end
end
