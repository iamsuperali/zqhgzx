class ChangeEventUserIdToUserApplicant < ActiveRecord::Migration
  def change
    add_column :events,:applicant,:string
    remove_column :events,:user_id,:integer
  end
end
