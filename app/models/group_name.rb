class GroupName
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :category_types

  field :name, type: String
  field :area, type: String
end
