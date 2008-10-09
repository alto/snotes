require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  context "Validating a user" do
    should_require_attributes :twitter_id
    should_require_attributes :name
  end
  
  context "Finding or creating a user" do
    should "return the user if it exists" do
      user = Factory(:user)
      assert_equal user, User.find_or_create!(user.twitter_id)
    end
    should "create a new user if it not yet exists" do
      assert_equal 0, User.count
      User.find_or_create!(2, :name => 'new user')
      assert_equal 1, User.count
    end
    should "fail if the newly created user is invalid" do
      assert_raise(ActiveRecord::RecordInvalid) { User.find_or_create!(2) }
    end
  end  
  
end
