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
      Tracking.delete_all
      Factory(:tweet, :parent_id => 1)
      assert_equal 0, Tracking.count
    end
    should "create a new note for it, if it's a root tweet" do
      Note.expects(:create_from_tweet!)
      Factory(:tweet, :parent_id => nil)
    end
    should "not create a new note for it, if it's a child tweet" do
      Note.delete_all
      Factory(:tweet, :parent_id => 1)
      assert_equal 0, Note.count
    end
  end

end
