class AddGradeOrgToUsers < ActiveRecord::Migration
  def change
    add_column :users, :grade, :integer
    add_column :users, :org_id, :integer
  end
end
