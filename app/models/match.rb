class Match < ActiveRecord::Base
  attr_accessible :black, :red, :sheet
  
  belongs_to :black, :class_name => "Rink", :foreign_key => "black_id"
  belongs_to :red, :class_name => "Rink", :foreign_key => "red_id"
  belongs_to :event
  
  def club
    c = Club.find_for_sheet(sheet)
    c.nil? ? 'Unknown' : c.name
  end
end
