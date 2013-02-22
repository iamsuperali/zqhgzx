class AddHitToPosts < ActiveRecord::Migration
  def change
    add_column :posts,:hit,:integer,:default=>0
  end
end
