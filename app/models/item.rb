class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :status
  belongs_to :categories

  field :name, type: String
end
