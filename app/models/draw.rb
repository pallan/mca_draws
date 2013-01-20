class Draw < ActiveRecord::Base
  attr_accessible :number, :partial
  
  has_many :matches
end
