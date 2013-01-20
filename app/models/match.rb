class Match < ActiveRecord::Base
  attr_accessible :black, :red, :sheet, :black_score, :red_score
  
  belongs_to :black, :class_name => "Rink", :foreign_key => "black_id"
  belongs_to :red, :class_name => "Rink", :foreign_key => "red_id"
  belongs_to :event
  
  def club
    c = Club.find_for_sheet(sheet)
    c.nil? ? 'Unknown' : c.name
  end
  
  def winner
    return unless complete?
    black_score.to_i > red_score.to_i ? black : red
  end
  
  def complete?
    !black_score.nil? && !red_score.nil?
  end
end
