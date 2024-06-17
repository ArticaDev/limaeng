class Building
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :checklist

  field :name, type: String
  field :area, type: String

end
