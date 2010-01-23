class PartyResult < ActiveRecord::Base

  belongs_to :constituency
  named_scope :for_year, lambda { |year| { :conditions => { :year => year } } }

  def self.distinct_years
    scoped(:select => "distinct(party_results.year)",:order => "party_results.year desc").collect(&:year)
  end

  add_google_label( :id => "name" ,:type => "string" , :label => "Party Name",:method => :name )
  add_google_label( :id => "percentage" ,:type => "number" ,:label => "Percentage",:method => :percentage )

  def bar_value
    {"c" => [ { "v" => year },{ "v" => name },{ "v" => percentage } ] }
  end

  class<<self
    def winner
      self.scoped(:order => "party_results.percentage DESC").first
    end
    def loser
      self.scoped(:order => "party_results.percentage DESC").last
    end
    def bar_chart_labels_for_year( year )
      default_labels = {"id" => "name" ,"type" => "string" ,"label" => "year"}
      parties_for_year(year).inject([ default_labels ]) do | cols, party|
        cols << { "id" => party.downcase, "type"=>"string", "label" => party }
      end
    end
    def parties_for_year( year )
      proxy = for_year( year ).scoped(:select => "distinct(party_results.name)",:order => "percentage desc")
      proxy.collect(&:name)
    end
    def bar_chart_values_for_year(year)
      results = find_all_by_year(year,:limit => 5,:order => "percentage desc")
      column = results.inject( [ {"v"=> year } ]) do | previous, result |
        previous << { "v" => result.percentage*total_votes }
      end
    end
  end

end
