class Snotes::Twitter
  SNOTE_TAG = '@snote'

  def self.search(query=SNOTE_TAG)
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

end
