# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApiController
      before_action :set_project, only: %i[show update destroy project_members add_member remove_member update_member]

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
          start_date: @project.start_date.strftime('%d-%m-%Y'),
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

      def update_member
        email = params[:user_email]
        role = params[:role]

        project_member = ProjectMember.find_by(user_email: email,
                                               project_id: @project.id)

        project_member.update!(role:)

        render json: project_member, status: :ok
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
        update_project_duration

        @project.update(project_params)

        render json: @project, status: :ok
      end

      def destroy
        @project.destroy

        render json: @project, status: :ok
      end

      def project_progress_status        
        GetProjectProgressionService.new(@project).call
      end

      private

      def update_project_duration
        new_duration = params[:duration_in_months] 
        
        return if new_duration.blank?
        return if new_duration == @project.duration_in_months
        
        UpdateProjectDurationService.new(@project.id, new_duration).call
      end

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
