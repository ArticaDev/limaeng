class CategoryType
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :item_type
  belongs_to :group_type

  field :name, type: String

end
