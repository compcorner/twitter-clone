class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet
      t.integer :user_id

      t.timestamps
    end
    add_index :tweets, [:user_id, :created_at]
  end
end
