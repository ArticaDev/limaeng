# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApiController
      before_action :set_project, only: %i[show update destroy]

      def index
        @projects = Project.all
        render json: @projects
      end

      def show
        render json: @project
      end

      def create
        @project = Project.create!(project_params)

        render json: @project, status: :created
      end

      def update
        @project.update(project_params)

        render json: @project, status: :ok
      end

      def destroy
        @project.destroy

        render json: @project, status: :ok
      end

      private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(
          :owner_name, :address_cep, :address_state,
          :address_city, :address_street, :address_neighborhood,
          :price_class, :has_parapent, :duration_in_months,
          :financial_institution, :start_date, :contract_date,
          floor_sizes: []
        )
      end
    end
  end
end
