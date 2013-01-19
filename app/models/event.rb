class Event < ActiveRecord::Base
  attr_accessible :bonspiel_id, :name
  
  belongs_to :bonspiel
  has_many :matches
end
