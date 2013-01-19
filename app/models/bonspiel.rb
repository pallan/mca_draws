class Bonspiel < ActiveRecord::Base
  attr_accessible :name
  
  has_many :draws
  has_many :events
end
