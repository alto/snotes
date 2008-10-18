require File.dirname(__FILE__) + '/../test_helper'

class TweetTest < ActiveSupport::TestCase

  context "A valid tweet" do
    should_require_attributes :twitter_id
    should_require_attributes :user_id
    should_require_attributes :message
    should_belong_to :user
  end

  context "Finding or creating a tweet" do
    should "return the tweet if it exists" do
      tweet = Factory(:tweet)
      assert_equal tweet, Tweet.find_or_create!(tweet.twitter_id)
    end
    should "create a new tweet if it not yet exists" do
      assert_equal 0, Tweet.count
      user = Factory(:user)
      Tweet.find_or_create!(2, :user_id => user.id, :message => 'new tweet')
      assert_equal 1, Tweet.count
    end
    should "fail if the newly created user is invalid" do
      assert_raise(ActiveRecord::RecordInvalid) { Tweet.find_or_create!(2) }
    end
  end
  
  context "Creating a new tweet" do
    should "create a tracking for it, if it's a root tweet" do
      Tracking.delete_all
      Factory(:tweet, :parent_id => nil)
      assert_equal 1, Tracking.count
    end
    should "not create a tracking for it, if it's a child tweet" do
      parent = Factory(:tweet)
      Tracking.delete_all
      Factory(:tweet, :parent_id => parent.id)
      assert_equal 0, Tracking.count
    end
    should "create a new note for it, if it's a root tweet" do
      Note.expects(:create_from_tweet!)
      Factory(:tweet, :parent_id => nil)
    end
    should "not create a new note for it, if it's a child tweet" do
      parent = Factory(:tweet)
      count = Note.count
      Factory(:tweet, :parent_id => parent.id)
      assert_equal count, Note.count
    end
    should "finished the parent note, if it's a child tweet without the matt operator" do
      parent = Factory(:tweet)
      Factory(:tweet, :parent_id => parent.id, :message => 'finished')
      note = Note.find_by_tweet_id(parent.id)
      assert_not_nil note.finished_at
    end
    should "not finished the parent note, if it's a child tweet with the matt operator" do
      parent = Factory(:tweet)
      Factory(:tweet, :parent_id => parent.id, :message => 'finished + ')
      note = Note.find_by_tweet_id(parent.id)
      assert_nil note.finished_at
    end
  end

end
