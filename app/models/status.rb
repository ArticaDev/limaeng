class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :item

  field :status, type: String

end
