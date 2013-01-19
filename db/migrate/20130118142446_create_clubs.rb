class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.integer :top_sheet
      t.integer :bottom_sheet

      t.timestamps
    end
  end
end
