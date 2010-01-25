class Decision < ActiveRecord::Base

  OVERVIEW_FIELDS = %w( winner defeated margin total_votes )

  belongs_to :contest
  belongs_to :contestant
  belongs_to :party

  validates_uniqueness_of :party_id,:scope => :contest_id
  validates_uniqueness_of :contestant_id,:scope => :contest_id

  named_scope :with_valid_party, { :conditions => ["decisions.party_id IS NOT NULL"], :include => :party }

  named_scope :with_valid_contestant, {
    :conditions => ["decisions.contestant_id IS NOT NULL"],
    :include => :contestant
  }

  #this named scope won't work until sibling scope include contest
  #i could have included contest but if sibling includes it ,this will cause table aliasing
  #this is intended used from association proxies which include contest
  #@assembly.descisions.for_year(2004)
  #Decision.for_year(2008).scoped(:include => :contest)
  named_scope :for_year,lambda { | year | { :conditions => { :contests => { :year => year } } } }

  def party_values
    party.google_value(self)
  end

  def contestant_values
    contestant.google_value(self)
  end

  def self.piecharts
    { "cols" => Party.google_columns, "rows" => with_valid_party.collect(&:party_values) }
  end

  def self.barcharts
    { "cols" => Contestant.google_columns, "rows" => with_valid_contestant.collect(&:contestant_values) }
  end

  def self.winner_votes
    self.scoped({}).maximum("decisions.votes")
  end

  def self.winner_decision
    scoped_by_votes(winner_votes).first
  end
  def self.defeated_decision
    scoped(:conditions => ["decisions.votes <> ?", winner_votes ],:limit => 1).first
  end

  def self.winner
    winner_decision.contestant_name
  end

  def self.defeated
    defeated_decision.contestant_name
  end

  def contestant_name
    self.try(:contestant).try(:name).try(:camelcase) || "Data Not Available"
  end

  def self.margin
    elected , runnerup = winner_decision, defeated_decision
    return "Data Not Available" if elected.nil? || runnerup.nil?
    elected.votes - runnerup.votes
  end

  def self.total_votes
    first.contest.votes
  end

  def self.overview
    OVERVIEW_FIELDS.inject({}) { | all, field | all.merge( field.to_sym => self.send( field.to_sym ) ) }
  end

end
