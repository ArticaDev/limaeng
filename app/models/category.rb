class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :checklist
  has_many :items

  field :name, type: String

end
