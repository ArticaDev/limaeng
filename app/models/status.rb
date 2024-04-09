class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :items

  field :status, type: String

end
