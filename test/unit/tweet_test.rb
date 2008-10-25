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
      Tweet.find_or_create!(2, :user_id => user.id, :message => '#start new tweet')
      assert_equal 1, Tweet.count
    end
    should "fail if the newly created user is invalid" do
      assert_raise(ActiveRecord::RecordInvalid) { Tweet.find_or_create!(2) }
    end
  end
  
  context "Creating a new tweet" do

    should "create a new note for it, if it's a root tweet" do
      Note.expects(:create_from_message!).with('#start new tweet').returns(Factory(:note))
      Factory(:tweet, :message => '#start new tweet')
    end
    should "not create a new note for it, if it's a child tweet" do
      root = Factory(:tweet, :message => '#start something')
      Note.expects(:create_from_message!).never
      tweet = Factory(:tweet, :message => 'anything', :user => root.user)
      assert_equal root.note, tweet.note
    end
    
    should "finish the note, if it's a child tweet with stop tag" do
      root = Factory(:tweet, :message => '#start something')
      Factory(:tweet, :message => '#stop', :user => root.user)
      assert_not_nil root.note.reload.finished_at
    end
    should "not finish the note, if it's a child tweet without stop tag" do
      root = Factory(:tweet, :message => '#start something')
      Factory(:tweet, :message => 'anything', :user => root.user)
      assert_nil root.note.reload.finished_at
    end
    
  end

end
