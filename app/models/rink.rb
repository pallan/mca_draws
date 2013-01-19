class Rink < ActiveRecord::Base
  attr_accessible :name, :club
  
  # belongs_to :club
  
  def to_s
    "#{name} (#{club})"
  end
end
