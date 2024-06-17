class Group
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :checklist
  has_many :category

  field :name, type: String
end
