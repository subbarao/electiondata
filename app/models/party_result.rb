class PartyResult < ActiveRecord::Base
  belongs_to :constituency
  def google_value
    {"c" => [{"v"=>name.to_s},{"v"=>percentage}]}
  end
  def self.google_label
    [
      {"id" => "name" ,"type" => "string" ,"label" => "Party Name"},
      {"id" => "percentage" ,"type" => "number" ,"label" => "Percentage"}
    ]
  end
end
