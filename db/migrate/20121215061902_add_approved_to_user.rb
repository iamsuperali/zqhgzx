class AddApprovedToUser < ActiveRecord::Migration
  def change
    add_column :users, :approved, :integer, :default => 0, :null => false
    add_index  :users, :approved
  end
end
