# frozen_string_literal: true

class ProjectMember
    include Mongoid::Document
    include Mongoid::Timestamps
  
    field :user_email, type: String
    field :project_id, type: String
    field :role, type: String
end
  