class Party < ActiveRecord::Base

  has_many :decisions

  add_google_label(:id => "party" ,:type => "string" , :method => lambda { | decision |
    decision.party.code
  })

  add_google_label(:id => "percentage" , :type => "number" , :method => lambda { | decision |
    decision.votes
  })

end
