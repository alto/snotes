require File.dirname(__FILE__) + '/../test_helper'

class TrackingTest < ActiveSupport::TestCase

  context "A valid tracking" do
    setup do
      @tracking = create_tracking
    end
    should_require_attributes :twitter_name
    should_require_unique_attributes :twitter_name
    should_require_attributes :tweet_id
    should_belong_to :tweet
  end

  context "Updating or creating a tracking" do
    should "return the tracking if it exists" do
      tracking = create_tracking
      assert_equal tracking, Tracking.update_or_create!(tracking.twitter_name)
    end
    should "create a new tracking if it not yet exists" do
      tweet = Factory(:tweet)
      Tracking.delete_all
      Tracking.update_or_create!('other_dude', :tweet_id => tweet.id)
      assert_equal 1, Tracking.count
    end
    should "fail if the newly created tweet is invalid" do
      assert_raise(ActiveRecord::RecordInvalid) { Tracking.update_or_create!('twitterer') }
    end
  end
  
  context "Conducting trackings" do
    setup do
      @tweet = Factory(:tweet)
      @tracking = create_tracking(@tweet)
    end
    
    should "iterate over trackings and start a twitter track" do
      Snotes::Twitter.expects(:track).with(@tracking.twitter_name, @tweet.twitter_id).returns(@tweet)
      assert_equal [@tweet], Tracking.conduct
    end
  end

end
