require 'test_helper'

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
end
