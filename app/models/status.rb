class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :checklist
  has_one :item

  field :status, type: String

end
