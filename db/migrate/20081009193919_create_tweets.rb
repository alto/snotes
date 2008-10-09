class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :user_id
      t.integer :twitter_id
      t.text    :message
      t.string  :language
      t.string  :image_url
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
