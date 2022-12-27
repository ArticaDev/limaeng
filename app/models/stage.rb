# frozen_string_literal: true

class Stage
    include Mongoid::Document
    include Mongoid::Timestamps
  
    embedded_in :project
  
    field :stage_type_id, type: BSON::ObjectId
    field :total_value, type: BigDecimal
    field :percentage_per_month, type: Hash, default: {}
  
    def stage_type
      StageType.find(stage_type_id)
    end
  end