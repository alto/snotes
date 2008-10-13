module Snotes
  class Twitter
  
    def self.search(query='#snote')
      results = ::Twitter::Search.new(query)
      if last_tweet = Tweet.find_last
        results = results.since(last_tweet.twitter_id)
      end
      results.each do |result|
        user = User.find_or_create!(result['from_user_id'], :name => result['from_user'])
        Tweet.find_or_create!(result['id'], :message => result['text'], :user_id => user.id,
          :language => result['iso_language_code'], :image_url => result['profile_image_url'])
      end
      results # TODO: do not return results (bug in twitter-0.3.7) [thorsten, 09.10.2008]
    end
  
  end
end
