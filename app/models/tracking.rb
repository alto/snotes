class Tracking < ActiveRecord::Base

  validates_presence_of :tweet_id
  validates_presence_of :twitter_name
  validates_uniqueness_of :twitter_name

  belongs_to :tweet

  # def conduct
  #   tweets = Snotes::Twitter.track(twitter_name)
  #   # what to do with the new tweets?
  # end

  def self.update_or_create!(twitter_name, attributes={})
    if tracking = find_by_twitter_name(twitter_name)
      tracking.update_attributes(attributes)
    else
      tracking = create!(attributes.merge(:twitter_name => twitter_name))
    end
    tracking
  end

end
