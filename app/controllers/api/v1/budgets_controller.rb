# frozen_string_literal: true

module Api
  module V1
    class BudgetsController < ApiController
      before_action :set_project, only: %i[show]

      def show
        project_budget = Budget::GetProjectBudgetService.new(@project).call
        render json: project_budget, status: :ok
      end

      private

      def set_project
        @project = Project.find(params[:id])
      end
    end
  end
end
