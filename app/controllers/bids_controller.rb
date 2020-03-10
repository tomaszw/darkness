class BidsController < ApplicationController
  permit 'index'
  
  def index
    @pms = PartyMember.find :all, 
      :conditions => [ 'member_id = ?', me.id ],
      :order => ['parties.partydate desc'],
      :include => [ :party ]
    render :action => :bids
  end
end
