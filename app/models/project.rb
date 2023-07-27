# frozen_string_literal: true

class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :state
  embeds_many :stages
  embeds_many :documents

  field :name, type: String

  field :address_cep, type: String
  field :address_city, type: String
  field :address_street, type: String
  field :address_neighborhood, type: String
  field :address_number, type: String
  field :address_complement, type: String

  field :price_class, type: String
  field :has_parapent, type: Mongoid::Boolean
  field :floor_sizes, type: Array, default: []
  field :duration_in_months, type: Integer
  field :financial_institution, type: String

  field :start_date, type: Date
  field :contract_date, type: Date

  field :last_generated_budget, type: String

  def last_generated_budget_hash
    return {} if last_generated_budget.blank?

    JSON.parse(last_generated_budget)
  end

  def price_per_meter
    state.send("#{price_class}_price_per_meter")
  end

  def total_area
    floor_sizes.sum
  end

  def total_cost
    if total_stages_budget.positive?
      total_stages_budget
    else
      (total_area * price_per_meter)
    end
  end

  def total_stages_budget
    stages.map(&:total_value).sum
  end

  def project_members
    ProjectMember.where(project_id: id.to_s)
  end

  def owner_name
    project_members.find_by(role: 'owner').user.name
  end
end
