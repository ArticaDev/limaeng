# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApiController
      before_action :set_project, only: %i[show update destroy project_members add_member remove_member]

      def index
        @projects = Project.all
        render json: @projects
      end

      def show
        progress_status = begin
          project_progress_status
        rescue StandardError => e
          { error: e.message }
        end
        project_data = {
          **@project.attributes.as_json.except('stages'),
          owner_name: @project.owner_name,
          months: months_array,
          progress_status:,
          total_project_percentage:
        }

        render json: project_data
      end

      def create
        state = State.find_by!(abbreviation: params[:address_state])
        @project = Project.create!(project_params.merge(state:))
        ProjectMember.create!(user_email: params[:user_email],
                              project_id: @project.id, role: 'owner')

        render json: @project, status: :created
      end

      def add_member
        email = params[:user_email]
        role = params[:role]
        job_title = params[:job_title]

        project_member = ProjectMember.create(user_email: email,
                                              project_id: @project.id, role:, job_title:)

        render json: project_member, status: :created
      end

      def remove_member
        email = params[:user_email]

        project_member = ProjectMember.find_by(user_email: email,
                                               project_id: @project.id)

        project_member.destroy

        render json: {}, status: :ok
      end

      def project_members
        members = @project.project_members.select { |member| member[:user_email].present? }.map do |member|
          {
            email: member.user_email,
            role: member.role,
            job_title: member.job_title,
            name: User.find_by(email: member.user_email)&.name || member.user_email
          }
        end.filter { |member| member[:role] != 'owner' }
        render json: members, status: :ok
      end

      def update
        @project.update(project_params)

        render json: @project, status: :ok
      end

      def destroy
        @project.destroy

        render json: @project, status: :ok
      end

      def project_progress_status        
        past_month = Date.today - 1.month
        project_start_date = @project.start_date
        duration = @project.duration_in_months
        monthly_situation = duration.times.map { 'on_time' }
        end_date = project_start_date + duration.months

        past_month_index = ((past_month - project_start_date).to_i / 30)
        total_scheduled_percentage = 100 * @project.stages.sum do |stage|
          (stage.percentage_per_month[0..past_month_index].sum/100)*stage.stage_type.coeficient
        end 

        (project_start_date..end_date).select { |date| date.day == 1 }.each do |date|
          stage_index = (date - project_start_date).to_i / 30
          stage_index = stage_index.abs

          @project.stages.each do |stage|
            scheduled_percentage_until_now = stage.percentage_per_month[0..stage_index].sum
            current_percentage = stage.current_percentage
            next if current_percentage >= scheduled_percentage_until_now
            monthly_situation[stage_index] = 'delayed'
            break
          end
        end

       
        is_on_time = monthly_situation[0..past_month_index].all? { |situation| situation == 'on_time' }
        months_ahead_or_behind = if is_on_time
                                   monthly_situation[past_month_index..].count { |situation| situation == 'on_time' }
                                 else
                                   monthly_situation[0..past_month_index].count { |situation| situation == 'delayed' }
                                 end

        situation = if project_start_date > Date.today
                      total_project_percentage.positive? ? 'ahead' : 'on_time' 
                    elsif is_on_time
                      months_ahead_or_behind.positive? ? 'ahead' : 'on_time'
                    else
                      'behind'
                    end

        total_scheduled_percentage = 0 if project_start_date > Date.today

        { situation:, months_ahead_or_behind:, total_scheduled_percentage: }
      end

      private

      def total_project_percentage
        return 0 if @project.stages.empty?

        @project.stages.map(&:current_total_percentage).sum
      end

      def months_array
        expected_end_date = @project.start_date + (@project.duration_in_months - 1).months

        (@project.start_date..expected_end_date).map do |date|
          date.strftime('%m-%y')
        end.uniq
      end

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(
          :address_cep, :address_state, :name,
          :address_city, :address_street, :address_neighborhood,
          :address_number, :address_complement,
          :price_class, :has_parapent, :duration_in_months,
          :financial_institution, :start_date, :contract_date,
          floor_sizes: []
        )
      end
    end
  end
end
