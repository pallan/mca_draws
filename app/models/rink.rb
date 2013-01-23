class Rink < ActiveRecord::Base
  attr_accessible :name, :club
  
  # belongs_to :club
  has_many :matches, :class_name => 'Match', :finder_sql => proc {['SELECT matches.* FROM matches WHERE black_id = :id OR red_id = :id', {id: id}]}
  
  def to_s
    "#{name} (#{club})"
  end
end
