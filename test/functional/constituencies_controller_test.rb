require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ConstituenciesControllerTest < ActionController::TestCase

  context "When user visits all page" do
    setup do
      flexmock(Constituency).should_receive(:all).returns([]).once
      get :all
    end
    should_assign_to :json
    should_respond_with :success
  end

  context "When user visits donothing page" do
    setup do
      flexmock(Constituency).should_receive(:all).returns([]).once
      get :donothing
    end
    should_assign_to :constituencies
    should_respond_with :success
  end

  context "When user clicks on page (which will trigger find), it " do
    setup do
      constituency = Factory(:constituency)
      flexmock(Constituency).should_receive(:find_closest).returns(constituency)
      get :find,:lat => 23,:lng => 37
    end
    should_respond_with :success
    should_assign_to(:con) { @con }
  end

end
