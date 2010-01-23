class Constituency < ActiveRecord::Base

  acts_as_mappable

  default_scope :conditions => ["constituencies.lat IS NOT NULL AND constituencies.lng IS NOT NULL"]

  has_many :nominations

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

    def table
      find(:all,:select => "year,winner,winning_party,runnerup,runnerup_party,(total_votes*1000)"<<
      " as total_votes,((winning_percentage-runnerup_percentage)*total_votes*10) as margin").inject({}) do |hash,val|
        hash.merge(val.year => val.attributes)
      end
    end
  end

  has_many :party_results do

    def google_obj(year)
      { "rows" => for_year(year).collect(&:google_value) }
    end

    def piedata
      columns = { "cols" => PartyResult.google_label }
      distinct_years.inject({}) do | hash , year |
        hash.merge( year => columns.merge(google_obj(year) ) )
      end
    end

    def barchart_by_year
      distinct_years.inject({}) do | hash, year |
        total_votes = proxy_owner.candidate_results.find_by_year(year).percentage
        results = find_all_by_year(year,:limit => 5,:order => "percentage desc")
        column = results.inject( [ {"v"=> year } ]) do | previous, result |
          previous << { "v" => result.percentage * total_votes }
        end
        hash.merge({ year => { "cols" => bar_chart_labels_for_year(year) , "rows" => [{ "c" =>  column  }] } })
      end
    end

    def with_party_results
      distinct_results.inject({}) do | hash, year |
        hash.merge( { year => find_by_year(year).attributes["name"] } )
      end
    end
  end
  def near
    Constituency.find(:all,:origin => self,:within=> 75).collect do |place|
      place.attributes.slice(*["name","id","lat","lng"]);
    end
  end
end
