require File.dirname(__FILE__) + '/../test_helper'

class NotesControllerTest < ActionController::TestCase

  context "Routing" do
    should "map index requests" do
      assert_routing('/', :controller => 'notes', :action => 'index')
    end
  end
  
  context "Requests to index (list notes)" do
    setup do
      @note = Factory(:note, :finished_at => Time.now)
    end

    should "succeed" do
      get :index
      assert_response :success
    end
    should "deliver finished notes" do
      Factory(:note)
      get :index
      assert_equal [@note], assigns(:notes)
    end
  end
  

end
