# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :checklists

  field :name, type: String
  field :email, type: String
  field :birth_date, type: String
  field :phone_number, type: String
  field :profile_picture_name, type: String

  def profile_picture_url
    return nil if profile_picture_name.nil?
    Amazon::AwsS3Service.new.file_url(profile_picture_name)
  end

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
        name: project.name,
        isOwner: member.role == 'owner',
        member: member.role
      }
    end
  end
end
