class AddNoteFinishedAt < ActiveRecord::Migration
  def self.up
    add_column :notes, :finished_at, :datetime
  end

  def self.down
    remove_column :notes, :finished_at
  end
end
