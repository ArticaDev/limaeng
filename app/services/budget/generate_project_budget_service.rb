# frozen_string_literal: true

module Budget
  class GenerateProjectBudgetService
    def initialize(project)
      @project = project
    end

    def call
      budget = stage_types.map do |stage_type|
        [stage_type.name, stage_cost(stage_type)]
      end
      budget.to_h
    end

    private

    def stage_cost(stage)
      (total_cost * stage.coeficient).round(2)
    end

    def total_cost
      @project.total_cost
    end

    def stage_types
      StageType.all
    end
  end
end
