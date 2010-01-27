require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
class SeatTest < ActiveSupport::TestCase

  context "Instance of seat" do

    setup { @seat = AssemblySeat.new(:name =>"city", :lat => 23, :lng =>27) }

    should "return data with barcharts/piecharts/overview/info" do
      assert_same_elements ["barcharts","piecharts","overview","info"],@seat.charts.keys
    end

    should "return name,lng,lat of seat" do
      expected = { "name" => @seat.name,"lat" => @seat.lat,"lng" => @seat.lng }
      assert_equal expected,@seat.core_info
    end

  end

  context "Instances of seat association proxies contests" do

    setup { @seat = AssemblySeat.new }

    should "be able to retrieve piecharts" do
      @contests = mock() { expects("values").returns("piecharts") }
      @seat.expects(:contests).returns(@contests)

      assert_equal 'piecharts', @seat.contests.values("piecharts")
    end

    should "be able to retrieve barcharts" do
      @contests = mock() { expects("values").returns("barcharts") }
      @seat.expects(:contests).returns(@contests)

      assert_equal 'barcharts', @seat.contests.values("barcharts")
    end

    should "be able to retrieve overview" do
      @contests = mock() { expects("values").returns("overview") }
      @seat.expects(:contests).returns(@contests)

      assert_equal 'overview', @seat.contests.values("overview")
    end

  end

  context "When class method all called on Seat classes, it" do

    setup do
      @notgeocoded= Factory(:assembly_seat,:lat => nil,:lng => nil)
      @geocoded   = Factory(:assembly_seat,:lat => 23.3,:lng => 24.4)
    end

    should "not return constituencies with lat/lng nil " do
      assert_does_not_contain AssemblySeat.all,@notgeocoded
    end

    should "return constituencies with lat/lng not nil " do
      assert_contains AssemblySeat.all,@geocoded
    end


  end
end
