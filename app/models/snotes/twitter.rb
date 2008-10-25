class Snotes::Twitter
  SNOTE_TAG = '@snote'

  class << self
    def search(query=SNOTE_TAG)
      logger.info "starting search for #{query}"
      results = ::Twitter::Search.new.to(query)
      if last_tweet = Tweet.find(:first, :order => 'created_at DESC')
        results = results.since(last_tweet.twitter_id)
      end
      results.collect do |result|
        logger.info "result: #{result.inspect}"
        if result != 'results'
          user = User.find_or_create!(result['from_user_id'], :name => result['from_user'])
          Tweet.find_or_create!(result['id'], :message => result['text'], :user_id => user.id,
            :language => result['iso_language_code'], :image_url => result['profile_image_url'])
        end
      end.compact
    end
    
    def autofollow
      logger.info 'starting autofollow'
      twitter = Twitter::Base.new(TWITTER_CONFIG['username'], TWITTER_CONFIG['password'])
      to_follow = twitter.followers.select do |u| 
        logger.info "to_follow(#{u.screen_name})"
        !twitter.friends.map{|f| f.screen_name }.include?(u.screen_name)
      end

      to_follow.each do |f|
        User.find_or_create!(f.id, :name => f.screen_name)
        begin
          twitter.create_friendship(f.id)
        rescue Twitter::CantConnect
          logger.error("-> didn't work, why? I don't know")
        end
      end
      logger.info "finished autofollow"
    rescue Twitter::CantConnect
      logger.error("twitter api")
    end
    
    def logger
      RAILS_DEFAULT_LOGGER
    end
  end # class << self
end
