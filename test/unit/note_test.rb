require File.dirname(__FILE__) + '/../test_helper'

class NoteTest < ActiveSupport::TestCase
  
  context "A valid note" do
    should_require_attributes :header
    should_require_attributes :tweet_id
    should_belong_to :tweet
  end
  
  context "Creating a note from a tweet" do
    setup do
      @parent = Factory(:tweet)
    end
    should "link the note with the tweet" do
      tweet = Factory(:tweet)
      note = Note.create_from_tweet!(tweet)
      assert_equal tweet, note.tweet
    end
    should "fully extract header and url" do
      tweet = Factory(:tweet, :message => '@snote This is a header http://test.com yeah')
      note = Note.create_from_tweet!(tweet)
      assert_equal "This is a header yeah", note.header
      assert_equal "http://test.com", note.url
    end
  end
  
  
end
