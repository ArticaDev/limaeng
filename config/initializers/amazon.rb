# frozen_string_literal: true

Rails.application.config.aws_region = ENV['AWS_REGION']
Rails.application.config.aws_credentials = Aws::Credentials.new(
  ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']
)
Rails.application.config.aws_bucket = ENV['AWS_BUCKET']
