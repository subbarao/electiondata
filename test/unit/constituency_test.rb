require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ConstituencyTest < ActiveSupport::TestCase

  context "Constituency all should " do
    setup do
      @unable_to_geocode  = Factory(:constituency,:lat => nil,:lng => nil,:distance => nil)
      @geocoded_city      = Factory(:constituency,:lat => 23.3,:lng => 23,:distance => nil)
    end
    should "return all geocoded cities" do
      assert_contains Constituency.all,  @geocoded_city
    end
    should "not return cities which system failed to geocode" do
      assert_does_not_contain Constituency.all,  @unable_to_geocode
    end
  end
  context "Constituency results association extension" do
    setup do
      @constituency  = Factory(:constituency,:lat => 23.3,:lng => 23,:distance => nil)
      @winner  = Factory(:result,:constituency_id => @constituency.id,:year => 2004,:votes =>90)
      @loser1  = Factory(:result,:constituency_id => @constituency.id,:year => 2004,:votes =>9)
      @loser2  = Factory(:result,:constituency_id => @constituency.id,:year => 2004,:votes =>1)
    end
    should " return in the order of votes" do
      assert_equal @constituency.results,[@winner,@loser1,@loser2]
    end
    should " return winner by calling winner" do
      assert_equal @winner,@constituency.results.for_year(2004).winner
    end
    should " return loser by calling loser" do
      assert_equal @loser2,@constituency.results.for_year(2004).loser
    end
  end

end
