##
#
# This must be called over script/runner (like in ./script/runner script/autofollow.rb)
# 
##

require 'twitter'


puts "connecting with #{TWITTER_CONFIG['username']} - #{TWITTER_CONFIG['password']}"

twitter = Twitter::Base.new(TWITTER_CONFIG['username'], TWITTER_CONFIG['password'])

to_follow = twitter.followers.select {|u| !twitter.friends.map{|f| f.screen_name }.include?(u.screen_name)}

puts to_follow.inspect
#twitter.follow(to_follow.first.screen_name)
to_follow.each do |f|
  puts "following #{f.screen_name}"
  User.find_or_create!(f.id, :name => f.screen_name)
  begin
    twitter.create_friendship(f.id)
  rescue Twitter::CantConnect
    puts "`-> didn't work, why? I don't know"
  end
end
