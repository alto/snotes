# == Schema Information
# Schema version: 20081024210037
#
# Table name: tweets
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)
#  twitter_id :integer(11)
#  message    :text
#  language   :string(255)
#  image_url  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tweet < ActiveRecord::Base
  
  validates_presence_of :user_id
  validates_presence_of :twitter_id
  validates_presence_of :message
  validates_presence_of :note_id
  
  belongs_to :user
  belongs_to :note
  
  before_validation :check_for_note
  
  # delegate :note, :to => :user
  
  def self.find_or_create!(twitter_id, attributes={})
    Tweet.find_by_twitter_id(twitter_id, name) ||
    Tweet.create!(attributes.merge(:twitter_id => twitter_id))
  end
  
  private
  
    def check_for_note
      if message =~ /#start/
        self.note = Note.create_from_message!(message)
      elsif user
        self.note = user.note
        if message =~ /#stop/
          note.update_attribute(:finished_at, Time.now)
        end
      end
    end

end
