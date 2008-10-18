# == Schema Information
# Schema version: 20081018190012
#
# Table name: trackings
#
#  id           :integer(11)     not null, primary key
#  tweet_id     :integer(11)
#  twitter_name :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Tracking < ActiveRecord::Base

  validates_presence_of :tweet_id
  validates_presence_of :twitter_name
  validates_uniqueness_of :twitter_name

  belongs_to :tweet

  def self.conduct
    tweets = []
    Tracking.all.each do |tracking| 
      tweets << Snotes::Twitter.track(tracking.twitter_name, tracking.tweet.twitter_id)
    end
    tweets.flatten
  end

  def self.update_or_create!(twitter_name, attributes={})
    if tracking = find_by_twitter_name(twitter_name)
      tracking.update_attributes(attributes)
    else
      tracking = create!(attributes.merge(:twitter_name => twitter_name))
    end
    tracking
  end

end
