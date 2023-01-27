# frozen_string_literal: true

module Api
    module V1
      class DocumentsController < ApiController
        before_action :set_project, only: %i[upload show]

        def upload
            file = params[:file]
            content = File.open(file.tempfile)
            filename = file.original_filename
            doc = UploadProjectFileService.new(
                @project, 
                content,
                filename
            ).call

            response = doc.as_json.merge(url: doc.url)
            render json: response, status: :ok
        end

        def show
            render json: project_documents, status: :ok
        end

        private

        def project_documents
            @project.documents.map do |doc|
                {
                    file_name: doc.name,
                    file_type: doc.file_type,
                    url: doc.url
                }
            end
        end

        def set_project
            @project = Project.find(params[:id])
        end
      end
    end
  end
  