require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ContestantTest < ActiveSupport::TestCase

  context "Instance of contestant" do

    should "return name in camelcase" do
      contestant = Contestant.new(:name => 'obama')
      assert_equal 'Obama',contestant.name
    end

    should "be able to retrieve google_values" do
      contest     = Factory(:contest)
      contestant  = Factory(:contestant, :name => 'winner')
      decision    = Factory(:decision,:contestant => contestant,   :votes => '20000')

      expected    = { "c" => [{"v"=>"Winner"},{"v"=>20}]  }

      assert_equal expected,contestant.google_value(decision)
    end

  end


  context "Google columns" do
    should "return defined google columns metadata" do
      assert_same_elements  Contestant.google_columns, [
        {:type=>"string", :label=>"Name", :id=>"name"},
        {:type=>"number", :label=>"Votes", :id=>"votes"}
      ]
    end
  end
end
