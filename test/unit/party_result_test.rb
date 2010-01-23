require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PartyResultTest < ActiveSupport::TestCase

  context "Constituency party_results association extension" do
    setup do
      @constituency  = Factory(:constituency,:lat => 23.3,:lng => 23,:distance => nil)

      @winner  = Factory(:party_result,{
        :constituency_id => @constituency.id,
        :year => 2004,
        :name =>"TDP",
        :percentage => 35
      })
      @loser  = Factory(:party_result,{
        :constituency_id => @constituency.id,
        :year => 2004,
        :name =>"BJP",
        :percentage => 25
      })
    end
    should " return all parties in the order of their percentages" do
      values = [{"id" => "name" ,"type" => "string" ,"label" => "year"}]
      values << {"id" => "tdp" ,"type" => "string" ,"label" => "TDP"}
      values << {"id" => "bjp" ,"type" => "string" ,"label" => "BJP"}
      assert_equal values,PartyResult.bar_chart_labels_for_year(2004)
      assert_equal ["TDP","BJP"],PartyResult.parties_for_year(2004)
    end
  end

  context "PartyResults" do

    setup do
      @constituency = Factory(:constituency)
      @pr1= Factory(:party_result,:constituency_id => @constituency.id,:year => 2004,:percentage => 90)
      @pr2 = Factory(:party_result,:constituency_id => @constituency.id,:year => 2004,:percentage => 9)
      @pr3 = Factory(:party_result,:constituency_id => @constituency.id,:year => 2004,:percentage => 1)
    end

    should "return all distinct years" do
      assert_equal [ 2004 ], PartyResult.distinct_years
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
  context "PartyResult class method " do
    should "return labels for google label for google_label" do
      values = [
        { :id => "name" ,:type => "string" , :label => "Party Name" },
        { :id => "percentage" ,:type => "number" ,:label => "Percentage" }
      ]
      assert_equal PartyResult.google_label, values
    end
  end

end
