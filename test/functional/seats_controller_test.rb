require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SeatsControllerTest < ActionController::TestCase

  context "when user visits index page,it" do
    setup do
      flexmock(Seat).should_receive(:find).once.and_return([])
      get :index
    end
    should_assign_to :seats
    should_respond_with :success
  end

  context "when user selects element,it" do
    setup do
      flexmock(Seat).should_receive(:find).once.and_return(flexmock(Seat.new))
      xml_http_request :get,:show,:id => 1
    end
    should_assign_to :seat
    should_respond_with :success
  end

  context "when user clicks on map page,it" do
    setup do
      flexmock(Seat).should_receive(:find_closest).once.and_return(flexmock(Seat.new))
      xml_http_request :get,:nearest,:lat => 23,:lng => 27
    end
    should_assign_to :seat
    should_respond_with :success
  end

end
