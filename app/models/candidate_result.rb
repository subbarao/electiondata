class CandidateResult < ActiveRecord::Base

  belongs_to :constituency

  named_scope :for_year,lambda{ |year| { :conditions => { :year => year } } }

  add_google_label(:id => "year",:type => "number",:label => "Year",:method => :year)
  add_google_label(:id => "winner",:type => "string",:label => "Winner",:method => :winner_info)
  add_google_label(:id => "run",:type => "string",:label => "Won Against",:method =>:runnerup_info)

  def winner_info
    "#{winner} (#{winning_party})"
  end

  def runnerup_info
    "#{runnerup} (#{runnerup_party})"
  end

  def percentage
    total_votes * 0.01
  end

  def results_by_year(  year )
    proxy = constituency.candidate_results.for_year(year)
    proxy.scoped(:limit => 5, :order => "percentage desc").inject( [ {"v"=> year } ]) do | previous, result |
      previous << { "v" => percentage * total_votes }
    end
  end

end
