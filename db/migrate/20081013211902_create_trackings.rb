class CreateTrackings < ActiveRecord::Migration
  def self.up
    create_table :trackings do |t|
      t.integer :tweet_id
      t.string :twitter_name
      t.timestamps
    end
  end

  def self.down
    drop_table :trackings
  end
end
