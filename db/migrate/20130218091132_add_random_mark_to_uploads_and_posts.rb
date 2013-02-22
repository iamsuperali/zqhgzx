class AddRandomMarkToUploadsAndPosts < ActiveRecord::Migration
  def change
    add_column :posts, :random_mark, :string,:limit=>8
    add_column :uploads, :random_mark, :string,:limit=>8
  end
end
