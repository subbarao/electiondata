class Contest < ActiveRecord::Base

  belongs_to :house,:polymorphic => true

  named_scope :for_year, lambda { |year| { :conditions => { :year => year } } }

  has_many :decisions do

    def winner
      find(:first,:order => "votes desc",:limit => 1)
    end

    def runnerup
      find(:first,:order => "votes desc",:limit => 1,:offset => 1)
    end

    def margin
      winner, runnerup = all(:order => "votes desc",:limit => 2)
      winner.votes - runnerup.votes
    end

    def for(contestant)
      find(:first,:conditions => { :contestant_id => contestant.id } )
    end

    def for_party(party)
      find(:first,:conditions => { :party_id => party.id } )
    end

  end

  has_many :contestants,:through => :decisions
  has_many :parties,:through => :decisions

  def overview
    {
      :winner   => decisions.winner.contestant.name ,
      :defeated => decisions.runnerup.contestant.name ,
      :margin   => decisions.margin ,
      :votes    => votes
    }
  end

  def barcharts
    { "cols" => Contestant.google_columns, "rows" => to_contestant_values }
  end

  def piecharts
    { "cols" => Party.google_columns, "rows" => to_party_values }
  end

  def to_contestant_values
    contestants.compact.collect { | contestant | contestant.google_value(decisions.for(contestant)) }
  end

  def to_party_values
    parties.compact.collect { | party | party.google_value(decisions.for_party(party)) }
  end


end
