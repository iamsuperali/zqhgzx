class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.integer :cate
      t.datetime :start_at
      t.datetime :end_at
      t.integer :start_node
      t.integer :end_node
      t.integer :created_by
      t.integer :approved_by
      t.string :remark

      t.timestamps
    end
  end
end
