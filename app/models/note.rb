# == Schema Information
# Schema version: 20081025192252
#
# Table name: notes
#
#  id          :integer(11)     not null, primary key
#  header      :string(255)
#  url         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  finished_at :datetime
#

class Note < ActiveRecord::Base
  
  validates_presence_of :header
  
  has_many :tweets, :order => 'created_at ASC'
  
  def self.create_from_message!(message)
    message_without_snote = message.gsub(/#{Snotes::Twitter::SNOTE_TAG}/,'').gsub(/#start/,'').strip
  
    if message_without_snote =~ /(.*) (http:\/\/.*)( .*)/ # TODO refine this [thorsten, 2008-10-16]
      header = "#{$1}#{$3}"
      url = $2
    else
      header = message_without_snote
      url = nil
    end
    create!(:header => header, :url => url)
  end
  
end
