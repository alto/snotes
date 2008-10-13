class Tweet < ActiveRecord::Base
  
  validates_presence_of :user_id
  validates_presence_of :twitter_id
  validates_presence_of :message
  
  belongs_to :user
  
  def self.find_or_create!(twitter_id, attributes={})
    Tweet.find_by_twitter_id(twitter_id, name) ||
    Tweet.create!(attributes.merge(:twitter_id => twitter_id))
  end
  
  def self.find_last
    find(:first, :order => 'created_at DESC')
  end
  
end
