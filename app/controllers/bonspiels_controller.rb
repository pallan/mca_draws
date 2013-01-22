class BonspielsController < ApplicationController
  
  caches_page :show
  caches_page :all
  
  def index
    b = Bonspiel.find(1)
    redirect_to bonspiel_path(b)
  end
  
  def show
    @bonspiel = Bonspiel.find(params[:id])
    @draws = @bonspiel.draws
  end

  def all
    @bonspiel = Bonspiel.find(params[:id])
    @draws = @bonspiel.draws
    render :action => :show
  end
  
  def load
    require 'open-uri'
    b = Bonspiel.find(params[:id])
    root_url = "http://www.curlmanitoba.org/"
    doc = Nokogiri::HTML(open(root_url + 'mca-mens-bonspiel'))
    draw_links = doc.css('p a').select{|link| link['href'].include?('/DRAW') || link['href'].include?('/PARTIAL-DRAW') }
    parsed = DrawParser.all.map(&:filename)
    draw_links.reject!{|link| parsed.include?(link['href']) }
    draw_links.each_with_index do |link, i|

      puts "Parsing #{link['href']}"
      match = /DRAW(\d*)/.match(link['href'])
      d = Draw.new(:number => match[1].to_i, :partial => link['href'].include?('PARTIAL'))
      io     = open(root_url + link['href'])
      reader = PDF::Reader.new(io)

      event = nil
      reader.pages.each do |page|
        found = false
        page.text.split("\n").each do |line|
          if line =~ /^      (.*?)/
            line = 'ASHAM' if line.include?('ASHAM FINALISTS')
            event = Event.where(:name => line.strip).first
            event = Event.create(:name => line.strip) if event.nil?

          end
          found = true if line.include?('SHEET')
          if found && line.length >= 82
            m       = Match.new
            m.event = event
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
    
    render :text => "Load attempted: #{draw_links.map{|l| l['href']}.inspect}"
  end
end
