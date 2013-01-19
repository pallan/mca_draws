class Club < ActiveRecord::Base
  attr_accessible :bottom_sheet, :name, :top_sheet
  
  def self.find_for_sheet(sheet)
    club_data = [[(1..9), "Granite"],
    [(41..48), "Heather"],
    [(51..56), "Fort Rouge"],
    [(71..75), "Elmwood"],
    [(91..96), "Deer Lodge"],
    [(101..106), "Pembina"],
    [(111..116), "Fort Garry"],
    [(121..125), "Victoria"],
    [(131..136), "St. Vital"],
    [(141..145), "West Kildonan"],
    [(161..165), "Thistle"],
    [(201..206), "Rossmere"],
    [(211..215), "Charleswood"],
    [(221..226), "Wildewood"],
    [(231..238), "Assiniboine Memorial"],
    [(241..244), "West St. Paul"],
    [(261..266), "East St Paul"],
    [(271..274), "Springfield"],
    [(281..283), "Stony Mountain"],
    [(301..303), "La Salle"],
    [(311..316), "Selkirk"],
    [(351..353), "St.Adolphe"]]
    
    club = club_data.select {|c| c[0].include?(sheet.to_i) }.first
    Club.new(:name => club[1]) if club
  end
  
end
