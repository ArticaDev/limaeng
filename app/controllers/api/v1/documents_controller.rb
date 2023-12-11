# frozen_string_literal: true

module Api
  module V1
    class DocumentsController < ApiController
      before_action :set_project, only: %i[upload show upload_as_json delete_file update_file_name]

      def upload
        file = params[:file]
        content = File.open(file.tempfile)
        original_filename = file.original_filename
        custom_filename = params[:filename]
        category = params[:category]
        doc = UploadProjectFileService.new(
          @project,
          content,
          original_filename,
          custom_filename,
          category
        ).call

        response = doc.as_json.merge(url: doc.url)
        render json: response, status: :ok
      end

      def upload_as_json
        decoded_file = Base64.decode64(params[:file_content])
        custom_filename = params[:filename]
        file_ext = params[:file_type]
        category = params[:category]

        file = Tempfile.new("temp_#{custom_filename}")
        file.binmode
        file.write(decoded_file)
        file.rewind

        doc = UploadProjectFileService.new(
          @project,
          file,
          "#{custom_filename}.#{file_ext}",
          custom_filename,
          category
        ).call

        file.close
        file.unlink

        response = doc.as_json.merge(url: doc.url)
        render json: response, status: :ok
      end

      def upload_generic
        decoded_file = Base64.decode64(params[:file_content])
        filename = params[:filename]
        file_ext = params[:file_type]

        file = Tempfile.new("temp_#{filename}")
        file.binmode
        file.write(decoded_file)
        file.rewind

        url = UploadDocumentService.new(
          file,
          "#{filename}.#{file_ext}",
        ).call

        file.close
        file.unlink

        render json: { url: }, status: :ok
      end

      def update_file_name
        file_key = params[:file_key]
        new_file_name = params[:name]
        @project.documents.find_by(file_key: file_key)&.update(name: new_file_name)

        render json: { message: 'File name updated successfully' }, status: :ok
      end

      def show
        render json: project_documents, status: :ok
      end

      def delete_file
        file_name = params[:filename]
        DeleteFileService.new(@project.id.to_s, file_name).call
      end

      private

      def project_documents
        @project.documents.map do |doc|
          {
            file_name: doc.name,
            file_type: doc.file_type,
            file_category: doc.category,
            url: doc.url,
            file_key: doc.file_key
          }
        end
      end

      def set_project
        @project = Project.find(params[:id])
      end
    end
  end
end
