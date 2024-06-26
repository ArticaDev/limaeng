class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :items
  belongs_to :checklist

  field :category_type_id, type: BSON::ObjectId
  field :items,type: Array
end
