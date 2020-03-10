class PartyMember < ActiveRecord::Base
  belongs_to :party
  belongs_to :member
  
  set_primary_keys :party_id, :member_id
  
  def dice_pts_used
    x = self[:dice_pts_used]
    x == nil ? 0 : x
  end
  
  def dice_pts_used=(x)
    self[:dice_pts_used] = x
  end
  
  def Username
    member.Username
  end
end
