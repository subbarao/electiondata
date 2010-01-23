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
  context "Constituency party_results association extension" do
    setup do
      @constituency  = Factory(:constituency,:lat => 23.3,:lng => 23,:distance => nil)

      @candidate_results  = Factory(:candidate_result,{
        :constituency_id => @constituency.id,
        :year => 2004,
        :winner => 'Obama',
        :winning_party => "TDP",
        :runnerup => "Mccain",
        :runnerup_party => "BJP",
        :total_votes =>90
      })

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
      @candidate_results_1999  = Factory(:candidate_result,{
        :constituency_id => @constituency.id,
        :year => 1999,
        :winner => 'Obama',
        :winning_party => "TDP",
        :runnerup => "Mccain",
        :runnerup_party => "CONG",
        :total_votes =>90
      })

      @winner_1999  = Factory(:party_result,{
        :constituency_id => @constituency.id,
        :year => 1999,
        :name =>"TDP",
        :percentage => 45
      })

      @loser_1999  = Factory(:party_result,{
        :constituency_id => @constituency.id,
        :year => 1999,
        :name =>"CONG",
        :percentage => 15
      })
    end

    should " return all contests google_value in the order of percentage votes" do
      assert_equal @winner.google_value,@constituency.party_results.google_obj(2004)["rows"].first
      assert_equal @loser.google_value,@constituency.party_results.google_obj(2004)["rows"].last
    end
    should " return all contests for all years piedata " do
      values_in_year = [@winner.google_value,@loser.google_value]
      assert_equal values_in_year,@constituency.party_results.piedata[2004]["rows"]
      assert_equal PartyResult.google_label,@constituency.party_results.piedata[2004]["cols"]
    end
    should "return party names in the order of their results" do

      values = [{"id" => "name" ,"type" => "string" ,"label" => "year"}]
      values << {"id" => "tdp" ,"type" => "string" ,"label" => "TDP"}
      values << {"id" => "bjp" ,"type" => "string" ,"label" => "BJP"}
      assert_equal values,@constituency.party_results.bar_chart_labels_for_year(2004)
      assert_equal ["TDP","BJP"],@constituency.party_results.parties_for_year(2004)
      assert_equal ["TDP","CONG"],@constituency.party_results.parties_for_year(1999)
      assert_equal values,@constituency.party_results.barchart_by_year[2004]["cols"]
      assert_equal [{"c"=>[{"v"=>2004}, {"v"=>31.5}, {"v"=>22.5}]}],@constituency.party_results.barchart_by_year[2004]["rows"]
      assert_equal [{"c"=>[{"v"=>1999}, {"v"=>40.5}, {"v"=>13.5}]}],@constituency.party_results.barchart_by_year[1999]["rows"]
    end

  end
end
