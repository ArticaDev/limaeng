# frozen_string_literal: true

module Budget
  class GenerateProjectBudgetService
    def initialize(project)
      @project = project
    end

    def call
      budget = stages.map do |stage|
        [stage.name, stage_cost(stage)]
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

    def stages
      Stage.all
    end
  end
end
