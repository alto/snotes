class RemoveTrackings < ActiveRecord::Migration
  def self.up
    drop_table :trackings
  end

  def self.down
    create_table :trackings do |t|
      t.integer :tweet_id
      t.string :twitter_name
      t.timestamps
    end
  end
end
