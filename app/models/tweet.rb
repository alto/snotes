# == Schema Information
# Schema version: 20081015220358
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
#  parent_id  :integer(11)
#

class Tweet < ActiveRecord::Base
  
  validates_presence_of :user_id
  validates_presence_of :twitter_id
  validates_presence_of :message
  
  belongs_to :user
  
  after_create :check_for_note
  after_create :check_for_tracking
  
  def self.find_or_create!(twitter_id, attributes={})
    Tweet.find_by_twitter_id(twitter_id, name) ||
    Tweet.create!(attributes.merge(:twitter_id => twitter_id))
  end
  
  def self.find_last
    find(:first, :order => 'created_at DESC')
  end
  
  def parent?
    parent_id.nil?
  end
  
  private
  
    def check_for_note
      if parent?
        Note.create_from_tweet!(self)
      elsif !message.strip.match(/\+$/) # ends on +
        Note.find_by_tweet_id(parent_id).update_attribute(:finished_at, Time.now)
      end
    end

    def check_for_tracking
      if parent_id.nil?
        Tracking.update_or_create!(self.user.name, :tweet_id => self.id)
      end
    end

end
