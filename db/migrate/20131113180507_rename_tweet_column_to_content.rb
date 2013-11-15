class RenameTweetColumnToContent < ActiveRecord::Migration
  def change
    rename_column :tweets, :tweet, :content
  end
end
