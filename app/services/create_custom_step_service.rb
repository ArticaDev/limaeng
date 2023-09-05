class CreateCustomStepService
    def initialize(project_id, step_name, step_cost)
        @project = Project.find(project_id)
        @step_name = step_name
        @step_cost = step_cost
    end

    def call
        @project.stages << stage
        @project.last_generated_budget = updated_budget.to_json
        adjust_other_percentages
        @project.save!
    end

    private 

    def adjust_other_percentages
        @project.stages.each do |stage|
            stage.custom_coeficient = (stage.total_value / @project.total_cost).to_f
        end
    end

    def updated_budget
        @project.last_generated_budget_hash.merge(
            @step_name => @step_cost
        )
    end

    def stage 
        Stage.new(stage_type_id: stage_type.id.to_s, percentage_per_month:,
            total_value: @step_cost, status_per_month:)
    end

    def percentage_per_month
        Array.new(@project.duration_in_months, 0)
    end
    
    def status_per_month
        Array.new(@project.duration_in_months, 'pending')
    end

    def stage_type
        StageType.create!(
            name: @step_name,
            coeficient: custom_step_coeficient,
            steps_description: step_description,
            isDefault: false,
            project_id: @project.id
        )
    end

    def custom_step_coeficient
        updated_cost = @project.total_cost + @step_cost
       (@step_cost / updated_cost).to_f
    end

    def step_description
        [
            { 
                'singleFloor' => true,
                'steps' => [@step_name], 
                'floorType' => 'others' 
            }
        ]
    end
end