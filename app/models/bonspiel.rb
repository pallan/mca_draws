class Bonspiel < ActiveRecord::Base
  attr_accessible :name
  
  has_many :draws, :order => 'draws.number desc'
  has_many :events
end
