class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :categories

  field :item_name, type: String
  field :categories, type: Integer
end
