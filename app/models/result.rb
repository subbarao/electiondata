class Result < ActiveRecord::Base

  belongs_to :party
  belongs_to :constituency

  named_scope :for_year,lambda { |year| { :conditions => { :year => year } } }

  class<<self
    def winner
      scoped(:order => "results.votes DESC").first
    end
    def loser
      scoped(:order => "results.votes DESC").last
    end
  end

end
