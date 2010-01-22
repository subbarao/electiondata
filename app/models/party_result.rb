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

end
