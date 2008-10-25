class AddTweetNoteId < ActiveRecord::Migration
  def self.up
    add_column :tweets, :note_id, :integer
  end

  def self.down
    remove_column :tweets, :note_id
  end
end
