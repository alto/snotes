require File.dirname(__FILE__) + '/../../test_helper'

class TwitterTest < ActiveSupport::TestCase

  context "Searching twitter" do
    setup do
      ::Twitter::Search.expects(:new).with('query').returns(mock_results)
    end
    should "deliver the results" do
      assert_equal mock_results, Snotes::Twitter.search('query')
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
