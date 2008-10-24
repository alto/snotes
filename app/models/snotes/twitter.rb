class Snotes::Twitter

  class << self
    def do_your_job
      tweets = search(SNOTE_TAG)
    end

    def search(query)
      results = ::Twitter::Search.new.to(query)
      if last_tweet = Tweet.find(:first, :order => 'created_at DESC')
        results = results.since(last_tweet.twitter_id)
      end
      results.collect do |result|
        if result != 'results'
          user = User.find_or_create!(result['from_user_id'], :name => result['from_user'])
          Tweet.find_or_create!(result['id'], :message => result['text'], :user_id => user.id,
            :language => result['iso_language_code'], :image_url => result['profile_image_url'])
        end
      end.compact
    end
    
    def autofollow
      logger.info("connecting with #{TWITTER_CONFIG['username']}")

      twitter = Twitter::Base.new(TWITTER_CONFIG['username'], TWITTER_CONFIG['password'])

      to_follow = twitter.followers.select {|u| !twitter.friends.map{|f| f.screen_name }.include?(u.screen_name)}

      to_follow.each do |f|
        User.find_or_create!(f.id, :name => f.screen_name)
        begin
          twitter.create_friendship(f.id)
        rescue Twitter::CantConnect
          logger.error("-> didn't work, why? I don't know")
        end
      end
    end
  end # class << self
end
