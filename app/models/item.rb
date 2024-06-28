class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :category
  belongs_to :item_type

  def name
    item_type.name
  end
  field :status, type: String
end
