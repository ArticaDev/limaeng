class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :status
  belongs_to :category

  field :name, type: String
end
