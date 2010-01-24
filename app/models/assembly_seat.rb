class AssemblySeat < Seat
  #has_many :nominations,:foreign_key => :seat_id,:class_name => "AssemblyNomination"
  #has_many :parties,:through => :nominations
end
