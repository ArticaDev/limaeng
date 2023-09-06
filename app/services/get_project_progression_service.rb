# frozen_string_literal: true

class GetProjectProgressionService
  def initialize(project)
    @project = project
  end

  def call
    past_month = Time.zone.today - 1.month
    project_start_date = @project.start_date
    duration = @project.duration_in_months
    monthly_situation = duration.times.map { 'on_time' }
    end_date = project_start_date + duration.months

    past_month_index = ((past_month - project_start_date).to_i / 30)
    total_scheduled_percentage = 100 * @project.stages.sum do |stage|
      (stage.percentage_per_month[0..past_month_index].sum / 100) * stage.coeficient
    end

    (project_start_date..end_date).select { |date| date.day == 1 }.each do |date|
      stage_index = (date - project_start_date).to_i / 30
      stage_index = stage_index.abs

      total_percentage_planned_for_month = @project.stages.sum do |stage|
        (stage.percentage_per_month[0..stage_index].sum / 100) * stage.coeficient
      end

      next_months_planned_percentage = @project.stages.sum do |stage|
        (stage.percentage_per_month[stage_index..].sum / 100) * stage.coeficient
      end

      if next_months_planned_percentage.zero?
        monthly_situation[stage_index..] = (duration - stage_index).times.map { 'unplanned' }
        break
      end

      monthly_situation[stage_index] =
        total_project_percentage >= total_percentage_planned_for_month ? 'on_time' : 'delayed'
    end

    is_on_time = monthly_situation[0..past_month_index].all? { |situation| situation == 'on_time' }

    months_ahead_or_behind = if is_on_time
                               monthly_situation[past_month_index + 1..].count do |situation|
                                 situation == 'on_time'
                               end
                             else
                               monthly_situation[0..past_month_index].count { |situation| situation == 'delayed' }
                             end

    situation = if project_start_date > Time.zone.today
                  total_project_percentage.positive? ? 'ahead' : 'on_time'
                elsif is_on_time
                  months_ahead_or_behind.positive? ? 'ahead' : 'on_time'
                else
                  'behind'
                end

    total_scheduled_percentage = 0 if project_start_date > Time.zone.today
    { situation:, months_ahead_or_behind:, total_scheduled_percentage: }
  end

  private

  def total_project_percentage
    return 0 if @project.stages.empty?

    @project.stages.map(&:current_total_percentage).sum
  end
end
