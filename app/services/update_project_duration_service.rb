class UpdateProjectDurationService
    def initialize(project_id, new_duration)
        @project = Project.find(project_id)
        @new_duration = new_duration
    end
    def call
        if @new_duration > @project.duration_in_months
            increase_project_duration()
        else
            decrease_project_duration()
        end
        @project.update(duration_in_months: new_duration)
    end

    private 

    def increase_project_duration
        @project.stages.each do |stage|
            stage.percentage_per_month = stage.percentage_per_month + Array.new(@new_duration - stage.percentage_per_month.length, 0)
            stage.status_per_month = stage.status_per_month + Array.new(@new_duration - stage.status_per_month.length, 'pending')
            stage.save
        end
    end

    def decrease_project_duration
        @project.stages.each do |stage|
            stage.percentage_per_month = stage.percentage_per_month[0..@new_duration - 1]
            stage.status_per_month = stage.status_per_month[0..@new_duration - 1]
            stage.save
        end
    end
end