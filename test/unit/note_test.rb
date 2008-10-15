require File.dirname(__FILE__) + '/../test_helper'

class NoteTest < ActiveSupport::TestCase
  
  context "A valid note" do
    should_require_attributes :header
    should_require_attributes :tweet_id
    should_belong_to :tweet
  end
  
  context "Creating a note from a tweet" do
    should "link the note with the tweet" do
      tweet = Factory(:tweet, :parent_id => 1)
      note = Note.create_from_tweet!(tweet)
      assert_equal tweet, note.tweet
    end
    should "fully extract header and url" do
      tweet = Factory(:tweet, :parent_id => 1, :message => '#snote This is a header http://test.com yeah')
      note = Note.create_from_tweet!(tweet)
      assert_equal "This is a header yeah", note.header
      assert_equal "http://test.com", note.url
    end
  end
  
  
end
