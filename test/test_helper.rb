ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

Factory.define(:party) do | f |
  f.sequence(:name) { |n| "SOME PARTY #{n}" }
  f.sequence(:code) { |n| "CDE#{n}" }
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
