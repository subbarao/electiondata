require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
class DecisionTest < ActiveSupport::TestCase

  context "When named_scope for_year queries with year,it" do
    setup do
      @tdp    = Factory(:party,:name => 'Telugu Desam', :code => 'TDP')
      @bjp    = Factory(:party,:name => 'Bharatiya',    :code => 'BJP')
      @cong   = Factory(:party,:name => 'Congress',     :code => 'CONG')

      @assembly   = Factory(:assembly_seat)
      @contest08 = Factory(:contest,:house => @assembly,:year => 2008,:votes => 25000)

      @winner08   = Factory(:decision,:contest => @contest08,:party => @tdp,:votes => 9000)
      @defeated08 = Factory(:decision,:contest => @contest08,:party => @bjp,:votes => 8000)
      @loser08    = Factory(:decision,:contest => @contest08,:party => @cong,:votes => 6000)

      @contest04 = Factory(:contest,:house => @assembly,:year => 2004,:votes => 15000)
      @winner04   = Factory(:decision,:contest => @contest04,:party => @tdp,:votes => 8000)
      @defeated04 = Factory(:decision,:contest => @contest04,:party => @cong,:votes => 4000)
      @loser04    = Factory(:decision,:contest => @contest04,:party => @bjp,:votes => 3000)

    end
    should "return decisions with correct year" do
      assert_same_elements @assembly.decisions.for_year(2008),[@winner08,@defeated08,@loser08]
      assert_same_elements @assembly.decisions.for_year(2004),[@winner04,@defeated04,@loser04]
    end

    should "return candidates with max votes as winner" do
      assert_equal Decision.for_year(2008).scoped(:include => :contest).winner,@winner08.contestant_name
      assert_equal Decision.for_year(2004).scoped(:include => :contest).winner,@winner04.contestant_name
    end

    should "return candidates with second max votes as defeated" do
      assert_equal Decision.for_year(2008).scoped(:include => :contest).defeated,@defeated08.contestant_name
      assert_equal Decision.for_year(2004).scoped(:include => :contest).defeated,@defeated04.contestant_name
    end

    should "return difference between winner and defeated of votes as margin" do
      assert_equal Decision.for_year(2008).scoped(:include => :contest).margin,1000
      assert_equal Decision.for_year(2004).scoped(:include => :contest).margin,4000
    end

    should "return data related election votes as margin" do
      assert Decision.for_year(2004).scoped(:include => :contest).overview[:winner],@winner04.contestant.name
      assert Decision.for_year(2008).scoped(:include => :contest).overview[:winner],@winner08.contestant.name
      assert Decision.for_year(2004).scoped(:include => :contest).overview[:defeated],@defeated04.contestant.name
      assert Decision.for_year(2008).scoped(:include => :contest).overview[:defeated],@defeated08.contestant.name
      assert Decision.for_year(2004).scoped(:include => :contest).overview[:margin],4000
      assert Decision.for_year(2008).scoped(:include => :contest).overview[:margin],1000
      assert Decision.for_year(2004).scoped(:include => :contest).overview[:total_votes],15000
      assert Decision.for_year(2008).scoped(:include => :contest).overview[:total_votes],25000
    end
    should "return data related election votes as when accessed through association proxy" do
      assert @assembly.decisions.for_year(2004).overview[:winner],@winner04.contestant.name
      assert @assembly.decisions.for_year(2008).overview[:winner],@winner08.contestant.name
      assert @assembly.decisions.for_year(2004).overview[:defeated],@defeated04.contestant.name
      assert @assembly.decisions.for_year(2008).overview[:defeated],@defeated08.contestant.name
      assert @assembly.decisions.for_year(2004).overview[:margin],4000
      assert @assembly.decisions.for_year(2008).overview[:margin],1000
      assert @assembly.decisions.for_year(2004).overview[:total_votes],15000
      assert @assembly.decisions.for_year(2008).overview[:total_votes],25000
    end

  end

  context " When instance method contestant_name ,it " do
    setup do
      @assembly   = Factory(:assembly_seat)
      @contest    = Factory(:contest,:house => @assembly,:year => 2004,:votes => 15000)
      @decision1  = Factory(:decision,:contest => @contest,:contestant => nil,:party => @bjp,:votes => 8000)
    end

    should "return data not available if contestant missing" do
      assert_same_elements @decision1.contestant_name,"Data Not Available"
    end

  end

  context " Decision named scopes" do
    setup do
      @bjp      = Factory(:party,:name => 'Bharatiya',:code => 'BJP')
      @tdp        = Factory(:party,:name => 'Telugu',   :code => 'TDP')
      @assembly   = Factory(:assembly_seat)
      @contest    = Factory(:contest,:house => @assembly,:year => 2004,:votes => 15000)
      @decision1  = Factory(:decision,:contest => @contest,:party => @bjp,:votes => 8000)
      @decision2  = Factory(:decision,:contest => @contest,:party => @tdp,:votes => 4000)
      @decision3  = Factory(:decision,:contest => @contest,:party => nil,:votes => 4000)
      @decision4  = Factory(:decision,:contest => @contest,:contestant => nil,:votes => 4000)
    end

    should "return all decisions with party_id not nil" do
      assert_same_elements Decision.with_valid_party,[@decision1,@decision2,@decision4]
    end
    should "return all decisions with contestandts not nil" do
      assert_same_elements Decision.with_valid_contestant,[@decision1,@decision2,@decision3]
    end
    should "return all decisions with for given year " do
      assert_same_elements Decision.for_year(2004).scoped(:include => :contest),[@decision1,@decision2,@decision3,@decision4]
    end
  end

  context "Instance methods extended from google_extensions" do
    setup do
      @bjpcont  = Factory(:contestant,:name => "BJP candidate")
      @tdpcont  = Factory(:contestant,:name => "TDP candidate")
      @bjp      = Factory(:party,:name => 'Bharatiya',:code => 'BJP')
      @tdp      = Factory(:party,:name => 'Telugu',   :code => 'TDP')

      @assembly   = Factory(:assembly_seat)
      @contest    = Factory(:contest,:house => @assembly,:year => 2004,:votes => 15000)
      @decision1  = Factory(:decision,:contest => @contest,:contestant => @bjpcont,:party => @bjp,:votes => 8000)
      @decision2  = Factory(:decision,:contest => @contest,:contestant => @tdpcont,:party => @tdp,:votes => 4000)
    end

    should "return columns metdata when google_label called" do
      assert_same_elements Party.google_columns,[{:type=>"string", :label=>"Party name", :id=>"party name"},
      {:type=>"number", :label=>"Percentage", :id=>"percentage"} ]
    end

    should "return columns values when google_values called" do
      assert_same_elements @decision1.party_values["c"],[{"v"=>"BJP"},{"v"=>8000}]
      assert_same_elements @decision2.party_values["c"],[{"v"=>"TDP"},{"v"=>4000}]
    end
    should "return columns values for contestants" do
      assert_equal @decision1.contestant_values["c"], [{"v"=>"BJP candidate"}, {"v"=>8 }]
    end
  end
end
