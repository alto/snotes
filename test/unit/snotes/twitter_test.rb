require File.dirname(__FILE__) + '/../../test_helper'

class TwitterTest < ActiveSupport::TestCase

  context "Searching twitter" do
    setup do
      ::Twitter::Search.expects(:new).with('query').returns(mock_results)
    end
    should "create a user" do
      User.delete_all
      Snotes::Twitter.search('query')
      user = User.first
      assert_equal 'enebo', user.name
      assert_equal 138109, user.twitter_id
    end
    should "create a tweet" do
      Tweet.delete_all
      Snotes::Twitter.search('query')
      tweet = Tweet.first
      assert_equal '@actionJackson_ Viel Erfolg! :-)', tweet.message
      assert_equal 'enebo', tweet.user.name
      assert_equal 944702192, tweet.twitter_id
      assert_equal "http://s3.amazonaws.com/twitter_production/profile_images/54854287/next2_small_normal.gif", tweet.image_url
      assert_equal 'de', tweet.language
    end
  end

  def mock_results
    [{ "text" => "@actionJackson_ Viel Erfolg! :-)", 
      "from_user" => "enebo", 
      "to_user" => "actionJackson_", 
      "to_user_id" => 588377, 
      "id" => 944702192, 
      "iso_language_code" => "de", 
      "from_user_id" => 138109, 
      "created_at" => "Fri, 03 Oct 2008 09:17:39 +0000", 
      "profile_image_url" => "http://s3.amazonaws.com/twitter_production/profile_images/54854287/next2_small_normal.gif"
    }]
  end

end
