class ItemType
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :category_type

  field :name, type: String
end
