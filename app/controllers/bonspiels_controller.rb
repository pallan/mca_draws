class BonspielsController < ApplicationController
  
  caches_page :show
  
  def index
  end
  
  def show
    @bonspiel = Bonspiel.find(params[:id])
  end
end
