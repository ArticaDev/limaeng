class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :category

  field :item_type_id, type: BSON::ObjectId
  field :name, type: String
  field :status, type: String
end
