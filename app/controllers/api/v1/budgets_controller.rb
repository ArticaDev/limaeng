# frozen_string_literal: true

module Api
  module V1
    class BudgetsController < ApiController
      before_action :set_project, only: %i[show]

      def show
        project_budget = @project.last_generated_budget_hash
        project_budget = generate_budget if project_budget.blank?

        project_budget = project_budget.merge(
          total_cost: @project.total_cost
        )

        render json: project_budget, status: :ok
      end

      private

      def generate_budget
        project_budget = Budget::GenerateProjectBudgetService.new(@project).call
        @project.update(last_generated_budget: project_budget.to_json)
        GenerateProjectStagesService.new(@project, project_budget).call
        project_budget
      end

      def set_project
        @project = Project.find(params[:id])
      end
    end
  end
end
