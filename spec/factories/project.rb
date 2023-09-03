# frozen_string_literal: true

FactoryBot.define do
    factory :project do
        state { create(:state) }
        name { Faker::Company.name }
        address_cep { Faker::Address.zip_code }
        address_city { Faker::Address.city }
        address_street { Faker::Address.street_name }
        address_neighborhood { Faker::Address.community }
        address_number { Faker::Address.building_number }
        address_complement { Faker::Address.secondary_address }
        price_class { 'economic' }
        has_parapent { false }
        floor_sizes { [Faker::Number.decimal(l_digits: 2)] }
        duration_in_months { Faker::Number.between(from: 1, to: 12) }
        financial_institution { Faker::Bank.name }
        start_date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
        contract_date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
        last_generated_budget { nil }
    end
end