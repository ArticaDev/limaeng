FactoryBot.define do 
    factory :state do
        name { Faker::Address.state }
        abbreviation { Faker::Address.state_abbr }
        low_price_per_meter { Faker::Number.decimal(l_digits: 2) }
        medium_price_per_meter { Faker::Number.decimal(l_digits: 2) }
        high_price_per_meter { Faker::Number.decimal(l_digits: 2) }
    end
end