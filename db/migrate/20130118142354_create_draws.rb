class CreateDraws < ActiveRecord::Migration
  def change
    create_table :draws do |t|
      t.integer :number
      t.integer :bonspiel_id
      t.timestamps
    end
  end
end
