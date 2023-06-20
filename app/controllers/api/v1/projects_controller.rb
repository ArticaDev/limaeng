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
        project_data = {
          **@project.attributes.as_json.except('stages'),
          months: months_array,
          total_project_percentage:
        }

        render json: project_data
      end

      def create
        state = State.find_by!(abbreviation: 'SP')
        @project = Project.create!(project_params.merge(state:))
        ProjectMember.create!(user_email: project_params[:user_email],
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
        members = @project.project_members.select{ |member| !member[:user_email].blank? }.map do |member|
          {
            email: member.user_email,
            role: member.role,
            job_title: member.job_title,
            name: User.find_by(email: member.user_email)&.name || member.user_email
          }
        end.filter { |member| member[:email] != @project.user_email }

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
          :user_email, :owner_name, floor_sizes: []
        )
      end
    end
  end
end
