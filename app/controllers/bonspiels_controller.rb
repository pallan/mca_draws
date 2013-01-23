class BonspielsController < ApplicationController
  
  caches_page :show
  
  def index
    b = Bonspiel.find(1)
    redirect_to bonspiel_path(b)
  end
  
  def show
    @bonspiel = Bonspiel.find(params[:id])
    @draws = @bonspiel.draws.limit(1)
  end
  
  def load
    @bonspiel = Bonspiel.find(params[:id])
    draw_links = @bonspiel.load_draws
    
    # Clear the cached pages
    expire_page :action => :show
    
    render :text => "Load attempted: #{draw_links.map{|l| l['href']}.inspect}"
  end
end
