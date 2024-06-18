class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :items
  belongs_to :group

  field :category_type_id, type: BSON::ObjectId
  field :name, type: String
  field :items,type: Array
end
