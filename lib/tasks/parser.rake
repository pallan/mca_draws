

namespace :app do
  
  task :load_results => :environment do
    require 'open-uri'
    root_url = "http://www.curlmanitoba.org/"
    doc = Nokogiri::HTML(open(root_url + 'mca-mens-bonspiel'))
    results_links = doc.css('p a').select{|link| link['href'].include?('/RESULTS-DRAW')}
    results_links.each_with_index do |link, i|
      
      puts "Parsing #{link['href']}"
      io     = open(root_url + link['href'])

      reader = PDF::Reader.new(io)

      reader.pages.each do |page|
        found = false
        page.text.split("\n").each_with_index do |line,x|
          found = true if line.include?('SHEET')
          if found && line.length >= 90
            line.insert(36,' ') if line.length > 90 && line =~ /^\s{4}/
            line = " #{line}" unless line =~ /^\s{4}/
            black_rink = line[6..36].strip
            black_score = line[46..50].strip.to_i
            red_score = line[91..93].strip
            red_rink = (line[45..46] =~ /\s{2}/ ? line[51..81] : line[49..81]).strip
          
            # puts "Checking; #{black_rink} vs. #{red_rink} '#{line[45..46]}'"
          
            black = Rink.where(:name => black_rink).first
            red =  Rink.where(:name => red_rink).first
          
            match = nil
            match = Match.where(:black_id => black.id, :red_id => red.id).first if black && red
            unless match.nil?
              match.update_attributes(:black_score => black_score, :red_score => red_score)
            end
          end
        end
      end
    end
    
  end
  
  task :load_draws => :environment do
    require 'open-uri'
    b = Bonspiel.first
    b = Bonspiel.new(:name => 'MCA 125') if b.nil?
    root_url = "http://www.curlmanitoba.org/"
    doc = Nokogiri::HTML(open(root_url + 'mca-mens-bonspiel'))
    draw_links = doc.css('p a').select{|link| link['href'].include?('/DRAW')}
    parsed = DrawParser.all.map(&:filename)
    draw_links.reject!{|link| parsed.include?(link['href']) }
    # draw_links = []
    # draw_links << {'href' => 'files/2013_MCA_Mens/DRAW01.pdf'}
    # draw_links << {'href' => 'files/2013_MCA_Mens/DRAW02.pdf'}
    # draw_links << {'href' => 'files/2013_MCA_Mens/DRAW03_1.pdf'}
    # draw_links << {'href' => 'files/2013_MCA_Mens/DRAW04.pdf'}
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