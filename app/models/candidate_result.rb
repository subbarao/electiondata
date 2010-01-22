class CandidateResult < ActiveRecord::Base
  belongs_to :constituency

  def google_value
    {"c" => [ {"v"=>year},{"v"=>"#{winner} (#{winning_party})"},
    {"v"=>"#{runnerup} (#{runnerup_party})"}]}
  end

  def self.google_label
    [
      {"id" => "year" ,"type" => "number" ,"label" => "Year"},
      {"id" => "winner" ,"type" => "string" ,"label" => "Winner"},
      {"id" => "run" ,"type" => "string" ,"label" => "Won Against"},
    ]
  end
end
