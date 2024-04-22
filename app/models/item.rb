class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :status
  belongs_to :category

  field :item_type_id, type: BSON::ObjectId
  field :status, type: String
end
