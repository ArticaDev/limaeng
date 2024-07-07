class GroupType
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :groups
  has_many :category_types

  field :name, type: String
end
