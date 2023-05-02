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

  validate :valid_total_percentage

  def initial_steps_progress
    stage_type = StageType.find(stage_type_id)
    number_of_instances = stage_type.singleFloor ? 1 : project.floor_sizes.count
    initial_progress = (1..number_of_instances).map{ |floor|
      floor_progression = {}
      return floor_progression if stage_type.steps.blank?
      stage_type.steps.each do |step|
        floor_progression[step] = 'pending'
      end
      floor_progression
    } 
    update(steps_progress: initial_progress)
    initial_progress
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

  def current_total_percentage 
    current_steps_progress.map{ |floor| floor.values.count('finished') }.sum * 100 / current_steps_progress.map{ |floor| floor.values.count }.sum
  end

end
