class SwitchTweetsAndNotes < ActiveRecord::Migration
  def self.up
    Note.all.each do |note|
      tweet = Tweet.find(note.tweet_id)
      tweet.update_attribute(:note_id, note.id)
    end
  end

  def self.down
    Tweet.all.each do |tweet|
      note = Note.find(tweet.note_id)
      note.update_attribute(:tweet_id, tweet.id)
    end
  end
end
