class Group
  include Mongoid::Document
  include Mongoid::Timestamps


  belongs_to :group_type
  belongs_to :checklist
  has_many :category

  def name
    group_type.name
  end
end
