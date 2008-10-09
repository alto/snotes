require 'factory_girl'

Factory.define :user do |u|
  u.twitter_id 1
  u.name 'dude'
end

Factory.define :tweet do |t|
  t.twitter_id 1
  t.association :user
  t.message 'message'
end
