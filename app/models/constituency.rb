class Constituency < ActiveRecord::Base

  has_many :results do
    def current_winner
      recent.first
    end
    def current_loser
      recent[1]
    end
    def recent
      find(:all,:conditions=>["year = 2004 "],:order => "votes DESC",:include=>[:party])
    end
  end

  has_many :candidate_results do
    def for_year(year)
      find_by_year(year)
    end
    def table
      rows = find( :all, :select => 'DISTINCT year' ).inject([]) do |hash,val|
        hash<< find_by_year(val.year).google_value
      end
      { "cols" => CandidateResult.google_label, "rows" => rows }
    end
  end

  has_many :party_results do
    def for_year(year)
      find(:all,:conditions=>["year = ? ",year],:order => "percentage DESC")
    end
    def google_obj(year)
      { "cols" => PartyResult.google_label, "rows" => for_year(year).collect(&:google_value) }
    end
    def piedata
      find( :all, :select => 'DISTINCT year' ).inject({}) do |hash,val|
        hash.merge({val.year => google_obj(val.year)})
      end
    end
  end
end
