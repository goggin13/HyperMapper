class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :id
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
