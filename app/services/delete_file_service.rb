class DeleteFileService
    def initialize(project_id, file_name)
        @project = Project.find(project_id)
        @file_name = file_name
    end

    def call
        file = @project.documents.find_by(name: @file_name)
        s3_service.delete_file(file&.file_key)
        file&.destroy
        @project.save 
    end

    def s3_service
        Amazon::AwsS3Service.new
    end
end