class AssemblyNomination < Nomination
  belongs_to :assembly, :class_name => "AssemblySeat", :foreign_key => "seat_id"
  validates_uniqueness_of :party_id,:scope => "seat_id"
  validates_presence_of  :name,:party_id,:seat_id
end
