# frozen_string_literal: true

module Api
  module V1
    class StagesController < ApiController
      before_action :set_project_and_stage, only: %i[update_stage stage update_stage_steps]
      before_action :set_project, only: %i[month stages_progression stage_steps create_custom_stage]

      def stage_types
        @stage_types = 
          StageType.where(isDefault: true)
          .or(StageType.where(project_id: @project.id))
        render json: @stage_types.map(&:name)
      end

      def update_stage
        month = params[:month]
        percentage = params[:percentage]

        stage_index = month_position(month)

        @stage.percentage_per_month[stage_index] = percentage.to_f if percentage

        @stage.save!

        render json: @stage, status: :ok
      end

      def stage
        render json: @stage
      end

      def all_percentage_per_month
        @project = Project.find(params[:id])
        @stages = @project.stages
        @stages_percentage_per_month = @stages.map do |stage|
          {
            name: stage.stage_type.name,
            percentages_per_month: stage.percentage_per_month
          }
        end

        @all_percentage_per_month = {
          stages_percentage_per_month: @stages_percentage_per_month,
          months: months_array
        }

        render json: @all_percentage_per_month
      end

      def month
        month = params[:month]
        stage_index = month_position(month)
        total_cost = 0
        month_stages = []

        @project.stages.each do |stage|
          next if stage.percentage_per_month[stage_index].zero?

          percentage = stage.percentage_per_month[stage_index]
          status = stage.status_per_month[stage_index]

          total_cost += stage.total_value * percentage / 100

          month_stages << {
            name: stage.stage_type.name,
            percentage:,
            status:

          }
        end

        render json: {
          total_cost:,
          stages: month_stages
        }
      end

      def stages_progression
        stages = @project.stages

        progression = stages.map do |stage|
          next if stage.percentage_per_month.sum.zero?

          {
            name: stage.stage_type.name,
            first_month: stage.percentage_per_month.index { |x| x != 0 },
            last_month: stage.percentage_per_month.rindex { |x| x != 0 } + 1
          }
        end.compact

        render json: {
          progression:,
          months: months_array
        }
      end

      def stage_steps
        progression = @project.stages.map do |stage|
          {
            name: stage.stage_type.name,
            steps_progression: stage.current_steps_progress,
            floor_types: stage.stage_type.steps_description.map{|step| step[:floorType]}.uniq,
          }
        end
        render json: {
          progression:,
          number_of_floors: @project.floor_sizes.count
        }
      end

      def update_stage_steps
        status = params[:status]
        floor_number = params[:floor]
        step_name = params[:step_name]
        floor_type = params[:floor_type]
        current_steps_progress = @stage.steps_progress
        floor_type_progress = current_steps_progress.find{|step| step["floor_type"] == floor_type}
        floor_type_progress["steps"][floor_number][step_name] = status
        @stage.save!
      end

      def create_custom_stage
        step_name = params[:step_name]
        step_cost = params[:step_cost]

        CreateCustomStepService.new(
          @project,
          step_name,
          step_cost
        ).call
      end

      private

      def month_position(month)
        ((@project.start_date - Date.strptime(month, '%m-%y')).to_f / 365 * 12).round.abs
      end

      def months_array
        expected_end_date = @project.start_date + (@project.duration_in_months - 1).months

        (@project.start_date..expected_end_date).map do |date|
          date.strftime('%m-%y')
        end.uniq
      end

      def set_project_and_stage
        @project = Project.find(params[:id])
        stage_name = params[:stage_type]
        @stage = @project.stages.select { |stage| stage.stage_type.name == stage_name }.first
      end

      def set_project
        @project = Project.find(params[:id])
      end
    end
  end
end
