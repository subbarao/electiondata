require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ContestTest < ActiveSupport::TestCase

  context "When association proxies for constest queried, they" do
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

    should "return winner when winner called" do
      assert_equal @parliament04.decisions.winner,@parliament104
    end

    should "return runnerup when runnerup called" do
      assert_equal @parliament04.decisions.runnerup,@parliament204
    end
  end

end