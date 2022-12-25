# frozen_string_literal: true

class State
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :projects, dependent: :nullify

  field :name, type: String
  field :abbreviation, type: String
  field :low_price_per_meter, type: BigDecimal
  field :medium_price_per_meter, type: BigDecimal
  field :high_price_per_meter, type: BigDecimal
end
