class Snotes::Twitter

  def self.search(query='#snote')
    tweets = []
    results = ::Twitter::Search.new(query)
    if last_tweet = Tweet.find_last
      results = results.since(last_tweet.twitter_id)
    end
    results.each do |result|
      if result != 'results'
        user = User.find_or_create!(result['from_user_id'], :name => result['from_user'])
        tweets << Tweet.find_or_create!(result['id'], :message => result['text'], :user_id => user.id,
          :language => result['iso_language_code'], :image_url => result['profile_image_url'])
      end
    end
    tweets
  end
  
  def self.track(name, tweet_id)
    tweets = []
    # puts "Searching Twitter from(#{name}) since(#{tweet_id})"
    results = ::Twitter::Search.new.from(name).since(tweet_id)
    results.each do |result|
      if result != 'results'
        user = User.find_by_name name
        parent = Tweet.first(:conditions => ['user_id = ? AND parent_id IS NULL', user.id], 
          :order => 'created_at DESC')
        tweets << Tweet.find_or_create!(result['id'], :message => result['text'], :user_id => user.id,
          :language => result['iso_language_code'], :image_url => result['profile_image_url'],
          :parent_id => parent.id)
      end
    end
    tweets
  end

end
