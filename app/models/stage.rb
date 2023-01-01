# frozen_string_literal: true

class Stage
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :project

  field :stage_type_id, type: BSON::ObjectId
  field :total_value, type: BigDecimal
  field :percentage_per_month, type: Array, default: []

  validate :valid_total_percentage

  def valid_total_percentage
    return if percentage_per_month.sum <= 100

    errors.add(:percentage_per_month, 'Total percentage must be less than or equal to 100')
  end


  def stage_type
    StageType.find(stage_type_id)
  end

  def current_total_percentage 
    return 0 if Date.today < project.start_date
    current_month = (project.start_date - Date.today.month).to_i/30
    current_month = stage_index.abs
    percentage_per_month[0..current_month].sum
  end

end
