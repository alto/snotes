class RemoveTweetParent < ActiveRecord::Migration
  def self.up
    remove_column :tweets, :parent_id
  end

  def self.down
    add_column :tweets, :parent_id, :integer, :default => nil
  end
end
