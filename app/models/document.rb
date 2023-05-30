# frozen_string_literal: true

class Document
    include Mongoid::Document
    include Mongoid::Timestamps
  
    embedded_in :project
  
    field :name, type: String
    field :file_type, type: String
    field :file_key, type: String
    field :category, type: String

    def url
        Amazon::AwsS3Service.new.file_url(file_key)
    end
end
  