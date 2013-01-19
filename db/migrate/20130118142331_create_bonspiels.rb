class CreateBonspiels < ActiveRecord::Migration
  def change
    create_table :bonspiels do |t|
      t.string :name

      t.timestamps
    end
  end
end
