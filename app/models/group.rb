class Group
  include Mongoid::Document
  include Mongoid::Timestamps

  field :group_type, type: String
  field :category, type: Array

  belongs_to :checklist
  has_many :category



end
