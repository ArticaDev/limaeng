class Checklist
  include Mongoid::Document
  include Mongoid::Timestamps
  field :userID, type: Integer
end
