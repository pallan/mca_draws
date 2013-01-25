class BracketFactory

  attr_accessor :competitors
  
  def self.generate(competitors)
    factory = BracketFactory.new(competitors) 
    return factory
  end

  def initialize(competitors)
    @bracket_size = next_power_of_two(competitors.size)
    @competitors = competitors + Array.new( @bracket_size - competitors.size )    
  end
  
  def pairings
    @pairings ||= seed_order(@bracket_size).map { |index| @competitors[index] }.each_slice(2).to_a
  end

  def simulate
    # Simulates the matches being played
    round_count = (Math.log(@bracket_size) / Math.log(2)).to_i
    rounds      = Array.new(round_count,[])
    rounds[0]   = pairings

    0.upto(round_count-1) do |r|
      rounds[r+1] = rounds[r].map {|pair| pair.compact.shuffle.first }.each_slice(2).to_a
    end
    return rounds
  end

protected

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