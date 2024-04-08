class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :items
  belongs_to :checklists

  field :item_status, type: Integer
  field :itemID, type: Integer
  field :checklistID, type: Integer
end
