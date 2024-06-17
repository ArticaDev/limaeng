class Checklist
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_one :building

  field :name, type: String

end
