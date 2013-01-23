class DrawsController < ApplicationController
  before_filter :find_bonspiel

  def index
    @draws = @bonspiel.draws
  end

  def show
    @draw = @bonspiel.draws.find(params[:id])
  end
  
  protected
  
  def find_bonspiel
    @bonspiel = Bonspiel.find(params[:bonspiel_id])
  end
end
