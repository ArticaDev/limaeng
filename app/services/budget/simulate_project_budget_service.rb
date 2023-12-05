# frozen_string_literal: true

module Budget
    class SimulateProjectBudgetService
      def initialize(cep, floor_sizes, price_standard)
        @cep = cep
        @floor = floor_sizes
        @price_standard = price_standard
      end
  
      def call
        budget = stage_types.map do |stage_type|
          [stage_type.name, stage_cost(stage_type)]
        end
        budget.to_h
      end
  
      private  

      def stage_cost(stage)
        (total_cost * stage.coeficient).round(2)
      end
  
      def total_cost
        total_area * price_per_meter
      end

      def total_area
        @floor.sum
      end

      def price_per_meter
        state_from_cep.send("#{@price_standard}_price_per_meter")
      end

      def state_from_cep     
        api_url = "https://viacep.com.br/ws/#{@cep}/json/"
        cep_info = JSON.parse(Net::HTTP.get(URI(api_url)))
        State.find_by(abbreviation: cep_info['uf'])
      end
  
      def stage_types
        StageType.where(isDefault: true).order_by(order: :asc)
      end
    end
  end
  