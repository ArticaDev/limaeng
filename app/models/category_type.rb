class CategoryType
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :items_type

  field :name, type: String

end
