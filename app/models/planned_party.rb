class PlannedParty < ActiveRecord::Base
  has_many :signups, :foreign_key => "party_id", :class_name => "PartySignup"
  belongs_to :requestor, :foreign_key => "requestor", :class_name => "Member"
  
  def signups_avail
    signups.select { |s| s.status == 'A' }
  end
  
  def signups_resigned
    signups.select { |s| s.status == 'R' }
  end
  
  def signups_uncertain
    signups.select { |s| s.status == 'U' }
  end
end
