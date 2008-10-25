class RemoveNoteTweetId < ActiveRecord::Migration
  def self.up
    remove_column :notes, :tweet_id
  end

  def self.down
    add_column :notes, :tweet_id, :integer
  end
end
