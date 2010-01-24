class Decision < ActiveRecord::Base

  belongs_to :contest
  belongs_to :party
  belongs_to :contestant

  validates_uniqueness_of :party_id,:scope => :contest_id
  validates_uniqueness_of :contestant_id,:scope => :contest_id

  named_scope :with_valid_party, { :conditions => ["decisions.party_id IS NOT NULL"], :include => :party }

  named_scope :with_valid_contestant, {
    :conditions => ["decisions.contestant_id IS NOT NULL"],
    :include => :contestant
  }

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

  def self.candidate_with_max_votes
  end

end
