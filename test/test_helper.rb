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
