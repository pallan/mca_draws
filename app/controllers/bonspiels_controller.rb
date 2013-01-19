class BonspielsController < ApplicationController
  
  caches_page :show
  
  def index
    b = Bonspiel.find(1)
    redirect_to bonspiel_path(b)
  end
  
  def show
    @bonspiel = Bonspiel.find(params[:id])
  end
  
  def load
    require 'open-uri'
    b = Bonspiel.find(params[:id])
    root_url = "http://www.curlmanitoba.org/"
    doc = Nokogiri::HTML(open(root_url + 'mca-mens-bonspiel'))
    draw_links = doc.css('p a').select{|link| link['href'].include?('/DRAW')}
    parsed = DrawParser.all.map(&:filename)
    draw_links.reject!{|link| parsed.include?(link['href']) }
    draw_links.each_with_index do |link, i|

      puts "Parsing #{link['href']}"
      match = /DRAW(\d*)/.match(link['href'])
      d = Draw.new(:number => match[1].to_i)
      io     = open(root_url + link['href'])
      reader = PDF::Reader.new(io)

      reader.pages.each do |page|
        found = false
        page.text.split("\n").each do |line|
          found = true if line.include?('SHEET')
          if found && line.length >= 82
            m       = Match.new
            m.black = Rink.where(:name => line[6..36].strip).first || Rink.new(:name => line[6..36].strip, :club => line[37..52].strip)
            m.red   = Rink.where(:name => line[52..82].strip).first || Rink.new(:name => line[52..82].strip, :club => line[83..-1].strip)
            m.sheet = line[0..5].strip
            d.matches << m
          end
        end
      end
      b.draws << d
      DrawParser.create(:filename => link['href'])
    end
    
    b.save!
    `rm -Rf #{Rails.root}/public/bonspiels`
  end
end
