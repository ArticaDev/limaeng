class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :items
  belongs_to :checklists

  field :name, type: String

end
