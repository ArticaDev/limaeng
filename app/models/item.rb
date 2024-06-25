class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :category

  field :item_type_id, type: BSON::ObjectId
  def name
    item_type.name
  end
  field :status, type: String
end
