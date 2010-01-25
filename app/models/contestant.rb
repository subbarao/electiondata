class Contestant < ActiveRecord::Base
  has_many :decisions
  has_many :contests,:through => :decisions

  add_google_label(:id => "name" ,:type => "string" , :method => lambda { | decision |
    decision.contestant.name
  })

  add_google_label(:id => "votes" , :type => "number" , :method => lambda { | decision |
    ( decision.votes || 0 )/1000
  })

end
