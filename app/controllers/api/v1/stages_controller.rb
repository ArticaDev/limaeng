# frozen_string_literal: true

module Api
    module V1
      class StagesController < ApiController
        before_action :set_project, only: %i[update_stage]


        def stage_types
          @stage_types = StageType.all
          render json: @stage_types.map(&:name)
        end

        def update_stage
            stage_type_id = StageType.find_by(name: params[:stage_type]).id.to_s
            stage = @project.stages.find(stage_type_id: stage_type_id)
            current_percentage_per_month = stage.percentage_per_month 
            
            month = params[:month].to_i
            percentage = params[:percentage].to_f

            current_percentage_per_month[month] = percentage
            stage.percentage_per_month = current_percentage_per_month
            stage.save!

            render json: stage, status: :ok
        end

        def stage 
            stage_type_id = StageType.find_by(name: params[:stage_type]).id.to_s
            @stage = @project.stages.find(stage_type_id: stage_type_id)
            render json: @stage
        end


      end
    end
  end
  