require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ResultTest < ActiveSupport::TestCase
  context "Result named_scope for_year" do
    setup do
      @winner = Factory(:result,:name => "Winner",:votes => 90,:percentage => 90,:year => 2004)
      @loser1 = Factory(:result,:name => "Loser1",:votes =>  9,:percentage => 9 ,:year => 2004)
      @loser2 = Factory(:result,:name => "Loser2",:votes =>  1,:percentage => 1 ,:year => 2004)
    end
    should "return results in the order of their votes" do
      assert_equal [@winner,@loser1,@loser2], Result.for_year(2004)
      assert_equal @winner, Result.for_year(2004).winner
      assert_equal @loser2, Result.for_year(2004).loser
    end
  end

end
