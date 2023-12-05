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

      def update
        @project = Project.find(params[:id])
        updated_budget = params[:budget]
        @project.stages.each do |stage|
          stage.update(total_value: updated_budget[stage.stage_type.name])
        end
        @project.update(last_generated_budget: updated_budget.to_json)

        render json: updated_budget, status: :ok
      end

      def simulate 
        cep = params[:cep]
        floor_sizes = params[:floor_sizes]
        price_standard = params[:price_standard]

        budget = Budget::SimulateProjectBudgetService.new(cep, floor_sizes, price_standard).call

        render json: budget, status: :ok
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
