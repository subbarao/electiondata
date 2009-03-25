class CandidateResult < ActiveRecord::Base
  belongs_to :constituency
  def google_value
    {"c" => [{"v"=>year},{"v"=>"#{winner} (#{winning_party})"},{"v"=>winning_percentage},
                      {"v"=>"#{runnerup} (#{runnerup_party})"},{"v"=>runnerup_percentage}]}
  end
  def self.google_label
    [
      {"id" => "year" ,"type" => "number" ,"label" => "Year"},
      {"id" => "winner" ,"type" => "string" ,"label" => "Winner"},
      {"id" => "win_percentage" ,"type" => "number" ,"label" => "% Votes"},
      {"id" => "run" ,"type" => "string" ,"label" => "Won Against"},
      {"id" => "run_percentage" ,"type" => "number" ,"label" => "% Votes"}
    ]
  end
end
