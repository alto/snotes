class Note < ActiveRecord::Base
  
  validates_presence_of :tweet_id
  validates_presence_of :header
  
  belongs_to :tweet
  
  def self.create_from_tweet!(tweet)
    message_without_snote = tweet.message.gsub(/#snote/,'').strip
  
    if message_without_snote =~ /(.*) (http:\/\/.*)( .*)/ # TODO refine this [thorsten, 2008-10-16]
      header = "#{$1}#{$3}"
      url = $2
    else
      header = message_without_snote
      url = nil
    end
    create!(:tweet_id => tweet.id, :header => header, :url => url)
  end
  
end