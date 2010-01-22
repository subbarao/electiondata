class Result < ActiveRecord::Base

  belongs_to :party
  belongs_to :constituency

  named_scope :for_year,lambda { |year| { :conditions => { :year => year } } }

  def self.winner
    self.scoped(:order => "results.votes DESC").first
  end

  def self.loser
    self.scoped(:order => "results.votes DESC").last
  end


end
