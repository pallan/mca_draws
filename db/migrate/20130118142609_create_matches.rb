class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :black_id
      t.integer :red_id
      t.integer :sheet
      t.integer :draw_id

      t.timestamps
    end
  end
end
