class PartySignup < ActiveRecord::Base
  # possible statuses:
  # S -> signed
  # R -> resigned
  
  set_primary_keys :party_id, :member_id
  belongs_to :party, :foreign_key => "party_id", :class_name => "PlannedParty"
  belongs_to :member
end
