# frozen_string_literal: true

class Stage
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :project

  field :stage_type_id, type: BSON::ObjectId
  field :total_value, type: BigDecimal
  field :percentage_per_month, type: Array, default: []
  field :status_per_month, type: Array, default: []
  field :steps_progress, type: Array, default: []
  field :custom_coeficient, type: BigDecimal

  validate :valid_total_percentage

  def initial_steps_progress
    stage_type = StageType.find(stage_type_id)
    steps_description = stage_type.steps_description
    all_steps_progress = []
    steps_description.each do |step_description|
      number_of_instances = step_description["singleFloor"] ? 1 : project.floor_sizes.count
      initial_progress = (1..number_of_instances).map  do |_floor|
        floor_progression = {}
        return floor_progression if step_description["steps"].blank?
  
        step_description["steps"].each do |step|
          floor_progression[step] = 'pending'
        end
        floor_progression
      end
      all_steps_progress << {floor_type:step_description["floorType"], steps: initial_progress}
    end 
    update(steps_progress: all_steps_progress)
    all_steps_progress
  end

  def current_steps_progress
    return initial_steps_progress if steps_progress.blank?

    steps_progress
  end

  def valid_total_percentage
    return if percentage_per_month.sum <= 100

    errors.add(:percentage_per_month, 'Total percentage must be less than or equal to 100')
  end

  def stage_type
    StageType.find(stage_type_id)
  end

  def current_percentage
    return 0 if current_steps_progress.blank?
    return 0 if current_steps_progress.first["steps"].blank?

    finished_steps_count = 0
    total_steps_count = 0
    
    current_steps_progress.each do |floor|
      floor["steps"].each do |step|
        total_steps_count += step.size
        step.each do |_, state|
          finished_steps_count += 1 if state == "finished"
        end
      end
    end
    
   (finished_steps_count.to_f / total_steps_count)
  end

  def current_total_percentage
    return 0 if coeficient.blank?
    current_percentage * coeficient
  end

  def coeficient 
    custom_coeficient || stage_type.coeficient
  end
end
