# frozen_string_literal: true

class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :owner_name, type: String

  field :address_cep, type: String
  field :address_state, type: String
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
end