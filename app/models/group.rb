class Group
  include Mongoid::Document
  include Mongoid::Timestamps


  belongs_to :group_type
  belongs_to :checklist
  has_many :category

  field :group_type, type: String



end
