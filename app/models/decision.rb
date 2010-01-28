class Decision < ActiveRecord::Base

  OVERVIEW_FIELDS = %w( winner defeated margin total_votes )

  belongs_to :contest
  belongs_to :contestant
  belongs_to :party

  validates_uniqueness_of :party_id,:scope => :contest_id
  validates_uniqueness_of :contestant_id,:scope => :contest_id

  default_scope :order => "decisions.votes desc"

  #this named scope won't work until sibling scope include contest
  #i could have included contest but if sibling includes it ,this will cause table aliasing
  #this is intended used from association proxies which include contest
  #@assembly.descisions.for_year(2004)
  #Decision.for_year(2008).scoped(:include => :contest)
  named_scope :for_year,lambda { | year | { :conditions => { :contests => { :year => year } } } }
  def contestant_name
    contestant.nil? ? 'Not Available' : contestant.name
  end

end
