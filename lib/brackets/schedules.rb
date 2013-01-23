Svcc.controllers :schedules do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  get :index do
    #@teams = Schedule.by_team
    @tems = {}
    render 'schedules/index'
  end

  get :bracket do
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

    @rinks = ['Deniset','Wingate','Cook','Scheurer','Tessmer','Thoroughgood','Kaneski','Shirtiffe','Meadows','Milloy','Fontaine','St. Laurent']#,'Van De Mosselaer','Dyck','Fenn','Dooley','Denyer','Boutin','Harcus','Lussier']
    @rinks.shuffle!

    bracket_size = next_power_of_two(@rinks.size)
    round_count = (Math.log(bracket_size) / Math.log(2)).to_i

    # groups = (bracket_size/4)-1
    # groups = [0] # 2
    # groups = [0,1] # 2
    groups = [0,2,1,3] # 4
    # groups = [0,4,2, 6,1, 5,3, 7] # 8
    # groups = [0,8,4,12,2,10,6,14] # 16

    matches = []
    slots = [0,2,1,3]

    slots.each do |slot|
      groups.each do |i|
        matches[i] ||= Array.new(4)
        matches[i][slot] = @rinks.shift
      end
    end
    pairings = []
    matches.each do |m|
      pairings += m.each_slice(2).to_a
    end

    rounds = Array.new(round_count,[])
    rounds[0] = pairings

    0.upto(round_count-1) do |r|
      puts r
      next_round = []
      rounds[r].each do |pair|
        next_round << pair.compact.shuffle.first
      end
      rounds[r+1] = next_round.each_slice(2).to_a
    end
    # puts pairings.inspect

    # @rinks = ['Deniset','Wingate','Cook','Scheurer','Tessmer','Thoroughgood','Kaneski','Shirtiffe','Meadows','Milloy','Fontaine','St. Laurent','Van De Mosselaer','Dyck','Fenn','Dooley','Denyer','Boutin','Harcus','Lussier']

    # @power = next_power_of_two(@rinks.size)

    # @rinks += Array.new((@power - @rinks.size), 'Bye')

    @rounds = JSON.generate({:rounds => rounds})

    render 'schedules/bracket'
  end


end
