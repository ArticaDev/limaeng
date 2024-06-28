class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :items
  belongs_to :group
  belongs_to :category_type
  def name
    category_type.name
  end
end
