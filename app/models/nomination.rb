class Nomination < ActiveRecord::Base
  belongs_to :party
  belongs_to :constituency
end
