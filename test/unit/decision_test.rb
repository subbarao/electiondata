require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
class DecisionTest < ActiveSupport::TestCase

  context "When named_scope for_year queries with year,it" do
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

    end
    should "return decisions with correct year" do
      assert_same_elements @assembly.decisions.for_year(2008),[@winner,@loser1,@loser2]
      assert_same_elements @assembly.decisions.for_year(2004),[@winner04,@loser104,@loser204]
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
      assert_same_elements @decision1.party_values["c"],[{"v"=>"Bharatiya"},{"v"=>8000}]
      assert_same_elements @decision2.party_values["c"],[{"v"=>"Telugu"},{"v"=>4000}]
    end
    should "return columns values for contestants" do
      assert_equal @decision1.contestant_values["c"], [{"v"=>"BJP candidate"}, {"v"=>8000}]
    end
  end
end
