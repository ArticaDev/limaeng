class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  field :item_name, type: String
  field :categories, type: Integer
end
