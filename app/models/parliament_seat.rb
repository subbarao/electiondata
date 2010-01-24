class ParliamentSeat < Seat
  #has_many :nominations,:foreign_key => :seat_id,:class_name => "ParliamentNomination"
  #has_many :parties,:through => :nominations
end
