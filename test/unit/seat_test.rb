require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
class SeatTest < ActiveSupport::TestCase

  context "When association proxies for decisions queried, they" do
    setup do
      @tdp    = Factory(:party,:name => 'Telugu Desam', :code => 'TDP')
      @bjp    = Factory(:party,:name => 'Bharatiya',    :code => 'BJP')
      @cong   = Factory(:party,:name => 'Congress',     :code => 'CONG')

      @assembly = Factory(:assembly_seat)
      @contest04= Factory(:contest,:house => @assembly,:year => 2004,:votes => 15000)
      @contest08= Factory(:contest,:house => @assembly,:year => 2008,:votes => 20000)
      @winner   = Factory(:decision,:contest => @contest08,:votes => 8000)
      @loser1   = Factory(:decision,:contest => @contest08,:votes => 4000)
      @loser2   = Factory(:decision,:contest => @contest08,:votes => 3000)

      @winner04 = Factory(:decision,:contest => @contest04,:votes => 8000)
      @loser104 = Factory(:decision,:contest => @contest04,:votes => 4000)
      @loser204 = Factory(:decision,:contest => @contest04,:votes => 3000)

      @parliament   = Factory(:parliament_seat)
      @parliament04 = Factory(:contest,:house => @parliament,:year => 2004,:votes => 15000)
      @parliament08 = Factory(:contest,:house => @parliament,:year => 2008,:votes => 20000)
      @parliament108   = Factory(:decision,:contest => @parliament08,:party => @bjp,:votes => 8000)
      @parliament208   = Factory(:decision,:contest => @parliament08,:party => @cong,:votes => 4000)
      @parliament308   = Factory(:decision,:contest => @parliament08,:party => @tdp,:votes => 3000)

      @parliament104 = Factory(:decision,:contest => @parliament04,:party => @tdp,:votes => 8000)
      @parliament204 = Factory(:decision,:contest => @parliament04,:party => @bjp,:votes => 4000)
      @parliament304 = Factory(:decision,:contest => @parliament04,:party => @cong,:votes => 3000)

    end

    should "return all years data when queried on barcharts" do
      assert_same_elements @assembly.barcharts.keys,["2008","2004"]
    end

    should "return defined column labels when queried on barcharts years" do
      assert_same_elements @assembly.barcharts["2008"]["cols"],Contestant.google_columns
      assert_same_elements @assembly.barcharts["2004"]["cols"],Contestant.google_columns
    end

    should "return all values data when queried on barcharts years" do
      values08 = [ @winner,@loser1,@loser2].collect { | decision | decision.contestant_values }
      values04 = [ @winner04,@loser104,@loser204].collect { | decision | decision.contestant_values }
      assert_same_elements @assembly.barcharts["2008"]["rows"],values08
      assert_same_elements @assembly.barcharts["2004"]["rows"],values04
    end
    should "return all years data when queried on partycharts" do
      assert_same_elements @assembly.piecharts.keys,["2008","2004"]
    end

    should "return defined column labels when queried on partycharts years" do
      assert_same_elements @assembly.piecharts["2008"]["cols"],Party.google_columns
      assert_same_elements @assembly.piecharts["2004"]["cols"],Party.google_columns
    end

    should "return all values data when queried on partycharts years" do
      values08 = [ @winner,@loser1,@loser2].collect { | decision | decision.party_values }
      values04 = [ @winner04,@loser104,@loser204].collect { | decision | decision.party_values }
      assert_same_elements @assembly.piecharts["2008"]["rows"],values08
      assert_same_elements @assembly.piecharts["2004"]["rows"],values04
    end

    should "return decisions with correct year for assembly elections" do
      assert_same_elements @assembly.decisions.for_year(2008),[@winner,@loser1,@loser2]
      assert_same_elements @assembly.decisions.for_year(2004),[@winner04,@loser104,@loser204]
    end

    should "return decisions with correct year for parliament elections" do
      assert_same_elements @parliament.decisions.for_year(2008),[@parliament108,@parliament208,@parliament308]
      assert_same_elements @parliament.decisions.for_year(2004),[@parliament104,@parliament204,@parliament304]
    end

    should "return contestants for year" do
      assert_same_elements @parliament.decisions.for_year(2008),[@parliament108,@parliament208,@parliament308]
      assert_same_elements @parliament.decisions.for_year(2004),[@parliament104,@parliament204,@parliament304]
    end

    should "return margin of victory  contest" do
      assert_equal @assembly.decisions.margin_of_victory(2008),4000
    end

    should "return winner for year" do
      assert_equal @assembly.decisions.winner(2008),@winner
    end

    should "return defeated for year" do
      assert_equal @assembly.decisions.defeated(2008),@loser1
    end

    should "return all barcharts/piecharts/overview" do
      assert_same_elements @parliament.charts.keys,["barcharts","piecharts","overview"]
      assert_same_elements @assembly.charts.keys,["barcharts","piecharts","overview"]
    end
    should "return all for each chart type" do
      assert_same_elements @parliament.charts["barcharts"].keys,["2008","2004"]
      assert_same_elements @parliament.charts["piecharts"].keys,["2008","2004"]
      assert_same_elements @parliament.charts["overview"].keys,["2008","2004"]
      assert_same_elements @assembly.charts["barcharts"].keys,["2008","2004"]
      assert_same_elements @assembly.charts["piecharts"].keys,["2008","2004"]
      assert_same_elements @assembly.charts["overview"].keys,["2008","2004"]
    end


    should "return all the data required to render ui for parliament" do
      assert @parliament.charts, {"barcharts"=>{"2004"=>{"rows"=>[{"c"=>[{"v"=>"contestant22"}, {"v"=>8000}]}, {"c"=>[{"v"=>"contestant23"}, {"v"=>4000}]}, {"c"=>[{"v"=>"contestant24"}, {"v"=>3000}]}], "cols"=>[{:type=>"string", :label=>"Name", :id=>"name"}, {:type=>"number", :label=>"Votes", :id=>"votes"}]}, "2008"=>{"rows"=>[{"c"=>[{"v"=>"contestant19"}, {"v"=>8000}]}, {"c"=>[{"v"=>"contestant20"}, {"v"=>4000}]}, {"c"=>[{"v"=>"contestant21"}, {"v"=>3000}]}], "cols"=>[{:type=>"string", :label=>"Name", :id=>"name"}, {:type=>"number", :label=>"Votes", :id=>"votes"}]}}, "piecharts"=>{"2004"=>{"rows"=>[{"c"=>[{"v"=>"Telugu Desam"}, {"v"=>8000}]}, {"c"=>[{"v"=>"Bharatiya"}, {"v"=>4000}]}, {"c"=>[{"v"=>"Congress"}, {"v"=>3000}]}], "cols"=>[{:type=>"string", :label=>"Party name", :id=>"party name"}, {:type=>"number", :label=>"Percentage", :id=>"percentage"}]}, "2008"=>{"rows"=>[{"c"=>[{"v"=>"Bharatiya"}, {"v"=>8000}]}, {"c"=>[{"v"=>"Congress"}, {"v"=>4000}]}, {"c"=>[{"v"=>"Telugu Desam"}, {"v"=>3000}]}], "cols"=>[{:type=>"string", :label=>"Party name", :id=>"party name"}, {:type=>"number", :label=>"Percentage", :id=>"percentage"}]}}, "overview"=>{"2004"=>{:winner=>"contestant22", :total_votes=>15000, :defeated=>"contestant23", :margin=>4000}, "2008"=>{:winner=>"contestant19", :total_votes=>20000, :defeated=>"contestant20", :margin=>4000}}}
    end

    should "return all the data required to render ui for assembly" do
      assert_equal @assembly.charts,{"barcharts"=>{"2004"=>{"rows"=>[{"c"=>[{"v"=>"contestant28"}, {"v"=>8000}]}, {"c"=>[{"v"=>"contestant29"}, {"v"=>4000}]}, {"c"=>[{"v"=>"contestant30"}, {"v"=>3000}]}], "cols"=>[{:type=>"string", :label=>"Name", :id=>"name"}, {:type=>"number", :label=>"Votes", :id=>"votes"}]}, "2008"=>{"rows"=>[{"c"=>[{"v"=>"contestant25"}, {"v"=>8000}]}, {"c"=>[{"v"=>"contestant26"}, {"v"=>4000}]}, {"c"=>[{"v"=>"contestant27"}, {"v"=>3000}]}], "cols"=>[{:type=>"string", :label=>"Name", :id=>"name"}, {:type=>"number", :label=>"Votes", :id=>"votes"}]}}, "piecharts"=>{"2004"=>{"rows"=>[{"c"=>[{"v"=>"SOME PARTY 16"}, {"v"=>8000}]}, {"c"=>[{"v"=>"SOME PARTY 17"}, {"v"=>4000}]}, {"c"=>[{"v"=>"SOME PARTY 18"}, {"v"=>3000}]}], "cols"=>[{:type=>"string", :label=>"Party name", :id=>"party name"}, {:type=>"number", :label=>"Percentage", :id=>"percentage"}]}, "2008"=>{"rows"=>[{"c"=>[{"v"=>"SOME PARTY 13"}, {"v"=>8000}]}, {"c"=>[{"v"=>"SOME PARTY 14"}, {"v"=>4000}]}, {"c"=>[{"v"=>"SOME PARTY 15"}, {"v"=>3000}]}], "cols"=>[{:type=>"string", :label=>"Party name", :id=>"party name"}, {:type=>"number", :label=>"Percentage", :id=>"percentage"}]}}, "overview"=>{"2004"=>{:total_votes=>15000, :winner=>"contestant28", :margin=>4000, :defeated=>"contestant29"}, "2008"=>{:total_votes=>20000, :winner=>"contestant25", :margin=>4000, :defeated=>"contestant26"}}}

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
