# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :birth_date, type: String
  field :phone_number, type: String

  def team_members
    ProjectMember.where(user_email: email)
  end

  def projects
    team_members.map do |member|
      project = Project.find(member.project_id)
      {
        id: project.id.to_s,
        owner_name: project.owner_name,
        address_street: project.address_street,
        isOwner: member.role == 'owner',
        member: member.role
      }
    end
  end
end
