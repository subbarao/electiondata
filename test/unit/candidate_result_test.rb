require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class CandidateResultTest < ActiveSupport::TestCase
  context "CandidateResult class method google_label" do
    should "return CandidateResult google_labels" do
      values= [
        {:id => "year" ,:type => "number" ,:label => "Year"},
        {:id => "winner" ,:type => "string" ,:label => "Winner"},
        {:id => "run" ,:type => "string" ,:label => "Won Against"}
      ]
      assert_equal values,CandidateResult.google_label
    end
  end
  context "CandidateResult instance methods" do
    setup do
      @constituency  = Factory(:constituency,:lat => 23.3,:lng => 23,:distance => nil)
      @candidate_results  = Factory(:candidate_result,{
        :constituency_id => @constituency.id,
        :year => 2004,
        :winner => 'Obama',
        :winning_party => "Democrats",
        :runnerup => "Mccain",
        :runnerup_party => "Republicans",
        :total_votes =>90
      })
    end
    should "return result values results_by_year" do
      assert_equal nil,@candidate_results.results_by_year(2004)
    end
    should "return winner info " do
      assert @candidate_results.winner_info,"Obama (Democrats)"
    end

    should "return runnerup info when called runnerup_info" do
      assert @candidate_results.runnerup_info,"Mccain (Republicans)"
    end
    should "return all info google label needs" do
      assert @candidate_results.google_value, { "c" => [{"v" => "Obama (Democrats)", "v"=> "Mccain (Republicans)"}]}
    end

  end


end
