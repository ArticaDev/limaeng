# frozen_string_literal: true

class StageType
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :coeficient, type: BigDecimal
  field :steps, type: Array, default: []
  field :singleFloor, type: Boolean, default: false
  field :order, type: Integer
end
