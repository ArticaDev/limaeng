# frozen_string_literal: true

module Api
  module V1
    class StagesController < ApiController
      before_action :set_project_and_stage, only: %i[update_stage stage update_stage_steps]
      before_action :set_project, only: %i[month stages_progression stage_steps]

      def stage_types
        @stage_types = StageType.all
        render json: @stage_types.map(&:name)
      end

      def update_stage
        
        month = params[:month]
        status = params[:status]
        percentage = params[:percentage]
        
        stage_index = (@project.start_date - Date.strptime(month,"%m-%y")).to_i/30
        stage_index = stage_index.abs


        if percentage
          @stage.percentage_per_month[stage_index] = percentage.to_f
        end

        if status
          @stage.status_per_month[stage_index] = status
        end

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
            percentages_per_month: stage.percentage_per_month,
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
        stage_index = (@project.start_date - Date.strptime(month,"%m-%y")).to_i/30
        stage_index = stage_index.abs

        total_cost = 0
        month_stages = []

        @project.stages.each {|stage|

          next if stage.percentage_per_month[stage_index].zero?

          percentage = stage.percentage_per_month[stage_index]
          status = stage.status_per_month[stage_index]

          total_cost += stage.total_value * percentage / 100

          month_stages << {
            name: stage.stage_type.name,
            percentage: percentage,
            status: status
            
          }

        }

        render json: {
          total_cost: total_cost,
          stages: month_stages
        }

      end

      def stages_progression
        stages = @project.stages

        progression = stages.map {|stage|

          next if stage.percentage_per_month.sum.zero?

          {
            name: stage.stage_type.name,
            first_month: stage.percentage_per_month.index {|x| x != 0},
            last_month: stage.percentage_per_month.rindex {|x| x != 0} + 1
          }

        }.compact

        render json: { 
          progression: progression,
          months: months_array
        }
      end

      def stage_steps 
        progression = @project.stages.map{ |stage|
          {
            name: stage.stage_type.name,
            steps: stage.current_steps_progress
          }
        }
        render json: {
          progression: progression,
          number_of_floors: @project.floor_sizes.count
        }
      end

      def update_stage_steps
        status = params[:status]
        floor_number = params[:floor]
        step_name = params[:step_name]
        current_steps_progress = @stage.steps_progress
        current_steps_progress[floor_number][step_name] = status
        @stage.save!
      end 

      private

      def months_array
        expected_end_date = @project.start_date + (@project.duration_in_months-1).months

        (@project.start_date..expected_end_date).map {|date|
          date.strftime("%m-%y")
        }.uniq
      end

      def set_project_and_stage
        @project = Project.find(params[:id])
        stage_type_id = StageType.find_by(name: params[:stage_type]).id.to_s
        @stage = @project.stages.find_by(stage_type_id:)
      end

      def set_project
        @project = Project.find(params[:id])
      end
    end
  end
end
