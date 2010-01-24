require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ContestantTest < ActiveSupport::TestCase
  context "Google columns" do
    should "return defined google columns metadata" do
      assert_same_elements  Contestant.google_columns, [
        {:type=>"string", :label=>"Name", :id=>"name"},
        {:type=>"number", :label=>"Votes", :id=>"votes"}
      ]
    end
  end
end
