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
          current_month: current_month,
          total_project_percentage: total_project_percentage,
          latest_stages: stages_to_render,
          months: months_array
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

        project_member = ProjectMember.create(user_email: email,
                              project_id: @project.id, role: role)

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
        members = @project.project_members.map { |member|
          {
            email: member.user_email,
            role: member.role,
            name: User.find_by(email: member.user_email).name
          }
        }.filter { |member| member[:email] != @project.user_email }

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

      def months_array
        expected_end_date = @project.start_date + (@project.duration_in_months-1).months

        (@project.start_date..expected_end_date).map {|date|
          date.strftime("%m-%y")
        }.uniq
      end

      def current_month
        (Date.today - @project.start_date).to_i / 30
      end

      def current_stages
        stages = @project.stages 

        return [] if stages.empty?

        stages.select do |stage|
          stage.percentage_per_month[current_month] > 0
        end
      end

      def latest_stages
        return [] if current_stages.empty?

        current_stages.map do |stage|
          {
            name: stage.stage_type.name,
            total_percentage: stage.current_total_percentage,
            value: stage.total_value * stage.percentage_per_month[current_month] / 100
          }
        end
      end

      def first_stages
        stages = @project.stages 

        return [] if stages.empty?

        first_stages = stages.select do |stage|
          stage.percentage_per_month[0] > 0
        end

        first_stages.map do |stage|
          {
            name: stage.stage_type.name,
            total_percentage: stage.current_total_percentage,
            value: stage.total_value * stage.percentage_per_month[0] / 100
          }
        end
      end

      def total_project_percentage
        
        return 0 if current_stages.empty?

        current_stages.map(&:current_total_percentage).sum
      end

      def stages_to_render
        return latest_stages unless latest_stages.blank?

        first_stages
      end

      def set_project
        
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(
          :address_cep, :address_state,
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
