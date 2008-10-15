class AddTweetParent < ActiveRecord::Migration
  def self.up
    add_column :tweets, :parent_id, :integer, :default => nil
  end

  def self.down
    remove_column :tweets, :parent_id
  end
end
