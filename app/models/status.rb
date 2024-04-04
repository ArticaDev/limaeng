class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  field :item_status, type: Integer
  field :itemID, type: Integer
  field :checklistID, type: Integer
end
