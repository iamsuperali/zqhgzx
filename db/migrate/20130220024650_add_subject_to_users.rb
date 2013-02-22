class AddSubjectToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subject, :integer
  end
end
