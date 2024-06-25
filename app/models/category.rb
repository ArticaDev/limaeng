class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :items
  belongs_to :group
  belongs_to :categories_type

  field :category_type_id, type: BSON::ObjectId
  field :items,type: Array
  def name
    category_type.name
  end
end
