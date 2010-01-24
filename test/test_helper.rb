ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require 'turn'
require 'phocus'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def self.setup_two_elections_data(&block)
    context "When two elections conducted " do
      setup do
        @tdp    = Factory(:party,:name => 'Telugu Desam', :code => 'TDP')
        @bjp    = Factory(:party,:name => 'Bharatiya',    :code => 'BJP')
        @cong   = Factory(:party,:name => 'Congress',     :code => 'CONG')

        @assembly_winner    = Factory(:contestant)
        @assembly_loser1    = Factory(:contestant)
        @assembly_loser2    = Factory(:contestant)

        @parliament_winner  = Factory(:contestant)
        @parliament_loser1    = Factory(:contestant)
        @parliament_loser2    = Factory(:contestant)

        @assembly     = Factory(:assembly_seat)
        @parliament   = Factory(:parliament_seat)

        @assembly08_contest  = Factory(:contest,:house => @assembly,:year => 2008,:votes => 20000 )
        @assembly04_contest  = Factory(:contest,:house => @assembly,:year => 2004,:votes => 20000 )
        @parliament08_contest  = Factory(:contest,:house => @parliament,:year => 2008,:votes => 20000 )
        @parliament04_contest  = Factory(:contest,:house => @parliament,:year => 2004,:votes => 20000 )

        @assembly08_decision_winner  = @assembly08_contest.decisions.create({
          :party      =>  @bjp,
          :contestant =>  @assembly_winner,
          :votes      =>  8000
        })

        @assembly08_decision_winner  = @assembly08_contest.decisions.create({
          :party      =>  @tdp,
          :contestant =>  @assembly_loser1,
          :votes      =>  6000
        })

        @assembly08_decision_winner  = @assembly08_contest.decisions.create({
          :party      =>  @cong,
          :contestant =>  @assembly_loser2,
          :votes      =>  3000
        })

        @assembly04_decision_winner  = @assembly04_contest.decisions.create({
          :party      =>  @bjp,
          :contestant =>  @assembly_winner,
          :votes      =>  8000
        })

        @assembly04_decision_winner  = @assembly04_contest.decisions.create({
          :party      =>  @tdp,
          :contestant =>  @assembly_loser1,
          :votes      =>  6000
        })

        @assembly04_decision_winner  = @assembly04_contest.decisions.create({
          :party      =>  @cong,
          :contestant =>  @assembly_loser2,
          :votes      =>  3000
        })

        @parliament08_decision_winner  = @parliament08_contest.decisions.create({
          :party      =>  @bjp,
          :contestant =>  @parliament_winner,
          :votes      =>  8000
        })

        @parliament08_decision_winner  = @parliament08_contest.decisions.create({
          :party      =>  @tdp,
          :contestant =>  @parliament_loser1,
          :votes      =>  6000
        })

        @parliament08_decision_winner  = @parliament08_contest.decisions.create({
          :party      =>  @cong,
          :contestant =>  @parliament_loser2,
          :votes      =>  3000
        })

        @parliament04_decision_winner  = @parliament04_contest.decisions.create({
          :party      =>  @bjp,
          :contestant =>  @parliament_winner,
          :votes      =>  8000
        })

        @parliament04_decision_winner  = @parliament04_contest.decisions.create({
          :party      =>  @tdp,
          :contestant =>  @parliament_loser1,
          :votes      =>  6000
        })

        @parliament04_decision_winner  = @parliament04_contest.decisions.create({
          :party      =>  @cong,
          :contestant =>  @parliament_loser2,
          :votes      =>  3000
        })
      end
      yield
    end
  end

end

Factory.define(:party) do | f |
  f.sequence(:name) { |n| "SOME PARTY #{n}" }
  f.sequence(:code) { |n| "CDE#{n}" }
end

Factory.define(:constituency) do | f |
  f.sequence(:name) { |n| "constituency#{n}" }
  f.sequence(:district) { |n| "district#{n}" }
  f.sequence(:category) { |n| "category#{n}" }
  f.lat 23.3
  f.lng 21.1
  f.distance 23.3
end


Factory.define(:result) do | r |
  r.association :party, :factory => :party
  r.sequence(:name) { |n| "senator#{n}" }
  r.sequence(:votes) { |n| n }
  r.sequence(:percentage) { |n| n }
  r.sequence(:year) { |n| n }
end


Factory.define(:party_result) do | r |
  r.association :constituency, :factory => :constituency
  r.sequence(:name) { |n| "party#{n}" }
  r.sequence(:percentage) { |n| n }
  r.sequence(:year) { |n| n }
end


Factory.define(:candidate_result) do | r |
  r.association :constituency, :factory => :constituency
  r.sequence(:winning_party) { |w| "winning_party#{w}" }
  r.sequence(:winner) { |w| "winner#{w}" }
  r.sequence(:runnerup_party) { |w| "runner_party#{w}" }
  r.sequence(:runnerup) { |w| "runner#{w}" }
  r.sequence(:year) { |w| w }
  r.turnout 60
  r.total_votes 300
  r.winning_percentage 130
  r.runnerup_percentage 40
end

Factory.define(:assembly_seat) do | f |
  f.sequence(:name) { |w| "assemblyseat#{w}" }
end

Factory.define(:parliament_seat) do | f |
  f.sequence(:name) { |w| "parliamentseat#{w}" }
end

Factory.define(:contestant) do | f |
  f.sequence(:name) { |w| "contestant#{w}" }
end

Factory.define(:contest) do | f |
  f.association(:house, :factory => :assembly_seat)
  f.year 2004
  f.votes 2000
end

Factory.define(:decision) do | f |
  f.association :party, :factory => :party
  f.association :contest, :factory => :contest
  f.association :contestant, :factory => :contestant
  f.votes 20000
end
