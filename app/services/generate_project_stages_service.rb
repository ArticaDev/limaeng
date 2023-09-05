# frozen_string_literal: true

class GenerateProjectStagesService
  def initialize(project, project_budget)
    @project = project
    @project_budget = project_budget
  end

  def call
    @project.stages = stage_types.map do |stage_type|
      Stage.new(stage_type_id: stage_type.id.to_s, percentage_per_month:,
                total_value: @project_budget[stage_type.name], status_per_month:)
    end
    @project.save!
  end

  def percentage_per_month
    Array.new(@project.duration_in_months, 0)
  end

  def status_per_month
    Array.new(@project.duration_in_months, 'pending')
  end

  def stage_types
    StageType.where(isDefault: true)
  end
end
