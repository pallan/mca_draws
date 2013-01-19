class CreateDrawParsers < ActiveRecord::Migration
  def change
    create_table :draw_parsers do |t|
      t.string :filename

      t.timestamps
    end
  end
end
