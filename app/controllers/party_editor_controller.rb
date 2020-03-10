class PartyEditorController < ApplicationController
  in_place_edit_for :party, 'name'
  in_place_edit_for :party, 'dice_factor'
  
  def index
    db_load
    render :action => :editor
  end
  
  def set_party_partydate
    p = Party.find params[:id]
    olddate = p.partydate
    p.partydate = params[:value]
    if not p.save or p.partydate.nil?
      p.partydate = olddate
      p.save
    end
    p.reload
    render :text => p.partydate.to_s
  end
  
  def set_member_effort
    id = params[:id].gsub '/', ','
    m = PartyMember.find id
    unless m.nil?
      m.effort = params[:value]
      m.save!
    end
    m.reload
    render :text => m.effort.to_s
  end
  
  def set_member_dice_pts_used
    id = params[:id].gsub '/', ','
    m = PartyMember.find id
    unless m.nil?
      m.dice_pts_used = params[:value]
      m.save!
    end
    m.reload
    render :text => m.dice_pts_used.to_s
  end

  def add_member
    p = Party.find @params[:party_id]
    m = Member.find @params[:added_member]
    p.add_member(m)
    redirect_to :action => :index, :id => @params[:party_id]
  end
 
  def del_member
    pm = PartyMember.find(@params[:party_id].to_i, @params[:member_id].to_i)
    pm.destroy unless pm.nil?
    redirect_to :action => :index, :id => @params[:party_id]    
  end
  
  def add_eq
    p = Party.find @params[:party_id]
    eq = Eq.find @params[:eq_id]
    p.add_eq(eq)
    redirect_to :action => :index, :id => @params[:party_id]
  end
   
  def del_eq
    eq = EqInstance.find(@params[:instance_id].to_i)
    eq.destroy unless eq.nil?
    redirect_to :action => :index, :id => @params[:party_id]    
  end
      
  private
  
  def db_load
    @party = Party.find params[:id]
    @members = @party.party_members.find(:all, :include => :member, :order => "username")
    @eqs = @party.eq_instances.find(:all, :include => :eq, :order => "sdesc")
    @added_member_opts = added_member_opts 
    @eq_opts = eq_opts 
  end
  
  def other_members
    cur_members = @party.party_members.find(:all).map { |x| x.member }
    all_members = Member.find :all
    all_members.find_all { |m|
     not cur_members.include?(m)
     }.sort { |a,b| a.Username<=>b.Username }
  end
  
  def added_member_opts
    mems = other_members
    mems.map { |m|
      "<option value=\"#{m.id}\">#{m.Username}</option>"
    }
  end
  
  def eq_opts
    Eq.find(:all, :order => "mob, sdesc").map { |eq|
      "<option value=\"#{eq.id}\">#{eq.mob}: #{eq.sdesc}</option>"
    }
  end
end
