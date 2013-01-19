class BonspielsController < ApplicationController
  
  caches_page :show
  
  def index
    b = Bonspiel.find(1)
    redirect_to bonspiel_path(b)
  end
  
  def show
    @bonspiel = Bonspiel.find(params[:id])
  end
end
