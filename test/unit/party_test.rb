require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PartyTest < ActiveSupport::TestCase
  context "Instance of party" do
    should "be able to retrieve google_values" do
      contest     = Factory(:contest)
      party       = Factory(:party, :code => 'GOP')
      decision    = Factory(:decision,:party => party,   :votes => '20000')

      expected    = { "c" => [{"v"=>"GOP"},{"v"=>20000}]  }

      assert_equal expected,party.google_value(decision)
    end
  end
end
