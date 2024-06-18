class Group
  include Mongoid::Document
  include Mongoid::Timestamps



  belongs_to :checklist
  has_many :category

  field :group_type, type: String
  field :category, type: Array



end
