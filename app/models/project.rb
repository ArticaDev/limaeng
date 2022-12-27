# frozen_string_literal: true

class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :state
  embeds_many :stages

  field :owner_name, type: String

  field :address_cep, type: String
  field :address_city, type: String
  field :address_street, type: String
  field :address_neighborhood, type: String

  field :price_class, type: String
  field :has_parapent, type: Mongoid::Boolean
  field :floor_sizes, type: Array, default: []
  field :duration_in_months, type: Integer
  field :financial_institution, type: String

  field :start_date, type: Date
  field :contract_date, type: Date

  def price_per_meter
    state.send("#{price_class}_price_per_meter")
  end

  def total_area
    floor_sizes.sum
  end

  def total_cost
    total_area * price_per_meter
  end
end
