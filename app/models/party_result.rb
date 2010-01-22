class PartyResult < ActiveRecord::Base

  belongs_to :constituency

  named_scope :for_year, lambda { |year| { :conditions => { :year => year } } }

  def google_value
    { "c" => [ { "v" => name },{ "v" => percentage } ] }
  end

  def bar_value
    {"c" => [ { "v" => year },{ "v" => name },{ "v" => percentage } ] }
  end

  def self.google_label
    [
      { "id" => "name" ,"type" => "string" , "label" => "Party Name" },
      { "id" => "percentage" ,"type" => "number" ,"label" => "Percentage" }
    ]
  end

  def self.winner
    self.scoped(:order => "party_results.percentage DESC").first
  end

  def self.loser
    self.scoped(:order => "party_results.percentage DESC").last
  end

end
