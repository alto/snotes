class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :tweet_id
      t.string  :header
      t.string  :url
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
