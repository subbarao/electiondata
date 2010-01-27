require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SeatsControllerTest < ActionController::TestCase

  context "when user visits index page,it" do
    setup do
      AssemblySeat.expects(:find).with(:all).returns([])
      get :index
    end
    should_assign_to :seats
    should_respond_with :success
  end

  context "when user selects element,it" do
    setup do
      seat = mock()
      seat.expects(:charts).with.returns({})
      AssemblySeat.expects(:find).with('2').returns(seat)
      xml_http_request :get,:show,:id => 2
    end
    should_assign_to :seat
    should_respond_with :success
  end

  context "when user clicks on map page,it" do
    setup do
      seat = mock()
      seat.expects(:charts).with.returns({})
      AssemblySeat.expects(:find_closest).with(:origin => ['23','27']).returns(seat)
      xml_http_request :get,:nearest,:lat => 23,:lng => 27
    end
    should_assign_to :seat
    should_respond_with :success
  end

end
