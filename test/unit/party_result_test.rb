require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PartyResultTest < ActiveSupport::TestCase
  context "PartyResults" do

    setup do
      @constituency = Factory(:constituency)
      @pr1= Factory(:party_result,:constituency_id => @constituency.id,:year => 2004,:percentage => 90)
      @pr2 = Factory(:party_result,:constituency_id => @constituency.id,:year => 2004,:percentage => 9)
      @pr3 = Factory(:party_result,:constituency_id => @constituency.id,:year => 2004,:percentage => 1)
    end

    should "return association proxy extension method winner return winner" do
      assert_equal @constituency.party_results.for_year(2004).winner,@pr1
      assert_equal @constituency.party_results.for_year(2004).loser,@pr3
    end

    should "return association proxy in their order" do
      assert_equal @constituency.party_results.for_year(2004),[@pr1,@pr2,@pr3]
    end

    should "return results in their order" do
      assert_equal @constituency.party_results,[@pr1,@pr2,@pr3]
    end

    should "return google with name and percentage hash" do
      assert_equal @pr1.google_value,{"c"=>[ { "v" => @pr1.name }, { "v" => @pr1.percentage } ]}
    end

    should "return bar_value with name and percentage hash" do
      assert_equal @pr1.bar_value,{"c"=>[{ "v" => @pr1.year },{"v" =>@pr1.name},{"v" =>@pr1.percentage }]}
    end

  end

end
