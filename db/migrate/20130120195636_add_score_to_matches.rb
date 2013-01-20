class AddScoreToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :black_score, :integer, :defult => nil
    add_column :matches, :red_score, :integer, :defult => nil
  end
end
