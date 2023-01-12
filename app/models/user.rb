# frozen_string_literal: true

class User
    include Mongoid::Document
    include Mongoid::Timestamps
  
    field :name, type: String
    field :email, type: String
    field :birth_date, type: String
    field :phone_number, type: String
  end
  