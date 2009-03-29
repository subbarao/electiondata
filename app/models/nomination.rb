class Nomination < ActiveRecord::Base
  belongs_to :party
  belongs_to :constituency
  validates_uniqueness_of :party_id, :scope => :constituency_id,:message => "Already candidate has been added"
  validates_presence_of :name,:party_id,:constituency_id
end
