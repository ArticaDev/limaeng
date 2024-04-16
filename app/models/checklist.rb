class Checklist
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_many :status

  field :name, type: String

end
