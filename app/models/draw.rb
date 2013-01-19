class Draw < ActiveRecord::Base
  attr_accessible :number
  
  has_many :matches
end
