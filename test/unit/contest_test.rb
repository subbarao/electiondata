require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ContestTest < ActiveSupport::TestCase

  context "Instance of contest" do

    setup do
      @contest  = Factory(:contest)
      @winner   = Factory(:decision,:contest => @contest, :votes => '20000')
      @runnerup = Factory(:decision,:contest => @contest, :votes => '9000')

      Factory(:decision,:contest => @contest, :votes => '4000')
      Factory(:decision,:contest => @contest, :votes => '3000')
    end

    should "return hash with winner/runnerup/votes/margin  values" do
      overview = @contest.overview

      assert_equal @winner.contestant.name,overview[:winner]
      assert_equal @runnerup.contestant.name,overview[:defeated]
      assert_equal @contest.votes,overview[:votes]
      assert_equal 11000,overview[:margin]
    end

    should "able to get contestant values in google visualization table format" do
      google_visualization = @contest.barcharts
      assert_same_elements ["cols","rows"], google_visualization.keys
      assert_same_elements Contestant.google_columns, google_visualization["cols"]
    end

    should "return all contestant google_values" do
      contest    = Contest.new
      contestant = mock()
      contestant.expects(:google_value).returns('googlevalue')
      contest.expects(:contestants).returns([contestant])
      assert_equal ['googlevalue'], contest.to_contestant_values
    end

  end

  context "Instance of contest decision association proxies " do

    setup do
      @contest  = Factory(:contest)
      @winner   = Factory(:decision,:contest => @contest, :votes => '20000')
      @runnerup = Factory(:decision,:contest => @contest, :votes => '9000')

      Factory(:decision,:contest => @contest, :votes => '4000')
      Factory(:decision,:contest => @contest, :votes => '3000')
    end

    should "know the winner" do
      assert_equal @winner, @contest.decisions.winner
    end

    should "know the runnerup" do
      assert_equal @runnerup, @contest.decisions.runnerup
    end

    should "know the victory margin" do
      assert_equal 11000,@contest.decisions.margin
    end

    should "be able retrieve decision when contestant is given" do
      assert_equal @winner ,  @contest.decisions.for(@winner.contestant)
      assert_equal @runnerup, @contest.decisions.for(@runnerup.contestant)
    end

  end

  context "Instance of contest contestants association proxies " do

    setup do
      @contest  = Factory(:contest)
      @winner   = Factory(:decision,:contest => @contest, :votes => '20000')
      @runnerup = Factory(:decision,:contest => @contest, :votes => '9000')

      Factory(:decision,:contest => @contest, :votes => '4000')
      Factory(:decision,:contest => @contest, :votes => '3000')
    end

    should "know the winner" do
      assert_equal @winner, @contest.decisions.winner
    end

    should "know the runnerup" do
      assert_equal @runnerup, @contest.decisions.runnerup
    end

    should "know the victory margin" do
      assert_equal 11000,@contest.decisions.margin
    end

    should "be able retrieve decision when contestant is given" do
      assert_equal @winner ,  @contest.decisions.for(@winner.contestant)
      assert_equal @runnerup, @contest.decisions.for(@runnerup.contestant)
    end

  end
end
