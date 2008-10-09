class User < ActiveRecord::Base
  
  validates_presence_of :name
  validates_presence_of :twitter_id
  
  def self.find_or_create!(twitter_id, attributes={})
    User.find_by_twitter_id(twitter_id) ||
    User.create!(attributes.merge(:twitter_id => twitter_id))
  end
  
end
