require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class DecisionTest < ActiveSupport::TestCase
  context "Instance of decision" do

    should "return 'Not Available' if contestant is nil" do
      decision = Decision.new
      assert_equal 'Not Available',decision.contestant_name
    end

    should "return contestant name if contestant is not nil" do
      decision            = Decision.new
      decision.contestant = Factory(:contestant,:name => 'obama')

      assert_equal 'Obama',decision.contestant_name
    end

  end

end
