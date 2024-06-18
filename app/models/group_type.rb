class GroupType
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name, type: String

  has_many :category_types

end
