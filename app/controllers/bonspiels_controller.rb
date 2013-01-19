class BonspielsController < ApplicationController
  
  def index
  end
  
  def show
    @bonspiel = Bonspiel.find(params[:id])
  end
end
