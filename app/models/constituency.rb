class Constituency < ActiveRecord::Base
  acts_as_mappable

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
      find(:all,:select => "year,winner,winning_party,runnerup,runnerup_party,(total_votes*1000) as total_votes,((winning_percentage-runnerup_percentage)*total_votes*10*turnout) as margin").inject({}) do |hash,val|
        hash.merge(val.year => val.attributes)
      end
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

    def barchart
      parties = find(:all,:order => "percentage desc").collect(&:name).uniq
      columns = parties.inject([{"id" => "name" ,"type" => "string" ,"label" => "year"}]) do | cols, party|
        cols << {"id"=>party.downcase, "type"=>"string", "label" => party }
      end
      results_in_hash = find( :all, :select => 'DISTINCT year' ).inject({}) do |hash,val|
        year_by_year = parties.collect do | party |
          party_result_for_year = find_by_year_and_name(val.year,party)
          party_result_for_year.nil? ? nil : party_result_for_year.percentage
        end
        hash.merge( val.year => year_by_year )
      end
      rows=[]
      results_in_hash.each_pair do |  key, values |
        column = values.inject([{"v"=>key.to_s}]) do | current_row, val |
          current_row << ( val.nil? ? nil : { "v" => val } )
        end
        rows << {"c" => column}
      end
      { "cols" => columns , "rows" => rows }
    end

    def barchart_by_year
      find( :all, :select => 'DISTINCT year' ,:order => "year desc").inject({}) do |hash,val|
        results = find_all_by_year(val.year,:limit => 5,:order => "percentage desc")
        parties = results.collect(&:name)
        ids = parties.inject([{"id" => "name" ,"type" => "string" ,"label" => "year"}]) do | cols, party|
          cols << {"id"=>party.downcase, "type"=>"string", "label" => party }
        end
        column = results.inject([{"v"=>val.year.to_s}]) do | previous, result |
          previous << { "v" => result.percentage }
        end
        hash.merge({ val.year => { "cols" => ids , "rows" => [{ "c" =>  column  }] } })
      end
    end
  end


  def near
    Constituency.find(:all,:origin => self,:within=> 75).collect do |place|
      place.attributes.slice(*["name","id","lat","lng"]);
    end
  end

end
