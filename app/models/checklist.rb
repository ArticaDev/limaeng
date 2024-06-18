class Checklist
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :name, type: String
  field :building_type, type: String

end
