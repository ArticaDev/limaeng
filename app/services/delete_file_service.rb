class DeleteFileService
    def initialize(project_id, file_key)
        @project = Project.find(project_id)
        @file_key = file_key
    end

    def call
        file = @project.documents.find_by(file_key: @file_key)
        s3_service.delete_file(file&.file_key)
        file&.destroy
        @project.save 
    end

    def s3_service
        Amazon::AwsS3Service.new
    end
end