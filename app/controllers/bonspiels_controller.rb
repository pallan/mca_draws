class BonspielsController < ApplicationController
  
  caches_page :show
  caches_page :all
  
  def index    
    rinks = Rink.limit(32).order('RAND()').all.map(&:name)    
    @bracket = BracketFactory.new(rinks)
    @rounds = JSON.generate(@bracket.simulate)
  end
  
  def show
    @bonspiel = Bonspiel.find(params[:id])
    @draws = @bonspiel.draws.order('number desc').limit(4)
  end

  def all
    @bonspiel = Bonspiel.find(params[:id])
    @draws = @bonspiel.draws.order('number desc')
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

  def next_power_of_two(n)
    return n if (n-1)&n == 0
    pow=1
    while (n >= 0x100000000) do  pow += 32; n >>= 32; end
    if (n & 0xFFFF0000 > 0) then pow += 16; n >>= 16; end
    if (n & 0xFF00 > 0)     then pow += 8;  n >>= 8;  end
    if (n & 0xF0 > 0)       then pow += 4;  n >>= 4; end
    if (n & 0xC > 0)        then pow += 2;  n >>= 2; end
    if (n & 0x2 > 0)        then pow += 1;  n >>= 1; end
    1<<pow
  end
  
  def seed_order(size)
    bracket_list = []
    0.upto(size-1) do |i|
      bracket_list << i
    end

    slice = 1
    while slice < bracket_list.length/2
      temp = bracket_list
      bracket_list = []

      while temp.length > 0
        bracket_list.concat temp.slice!(0, slice)       # n from the beginning
        bracket_list.concat temp.slice!(-slice, slice)  # n from the end
      end

      slice *= 2
    end

    bracket_list
  end  

end
