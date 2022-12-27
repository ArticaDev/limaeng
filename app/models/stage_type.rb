# frozen_string_literal: true

class StageType
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :coeficient, type: BigDecimal
end
