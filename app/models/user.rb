# == Schema Information
# Schema version: 20081025192252
#
# Table name: users
#
#  id         :integer(11)     not null, primary key
#  name       :string(255)
#  twitter_id :integer(11)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  
  validates_presence_of :name
  validates_presence_of :twitter_id
  
  def self.find_or_create!(twitter_id, attributes={})
    User.find_by_twitter_id(twitter_id) ||
    User.create!(attributes.merge(:twitter_id => twitter_id))
  end
  
  def note
    Note.first(:conditions => ['id IN (SELECT note_id FROM tweets WHERE user_id = ?)', id])
  end
  
end
