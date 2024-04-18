class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :status
  belongs_to :category

  field :name, type: String
  field :status, type: String
end
