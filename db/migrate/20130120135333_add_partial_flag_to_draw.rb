class AddPartialFlagToDraw < ActiveRecord::Migration
  def change
    add_column :draws, :partial, :boolean
  end
end
