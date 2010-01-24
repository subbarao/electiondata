class Contest < ActiveRecord::Base

  belongs_to :house,:polymorphic => true
  named_scope :for_year, lambda { |year| { :conditions => { :year => year } } }

  has_many :decisions do
    def winner
      find(:first,:order => "votes desc",:limit => 1)
    end
    def runnerup
      find(:first,:order => "votes desc",:limit => 1,:offset => 1)
    end
  end

end
