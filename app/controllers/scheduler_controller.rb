class SchedulerController < ApplicationController
  permit 'index'
  permit 'edit'
  permit 'remove'
  permit 'add_request'
  permit 'save_party'
  permit 'signup'
  permit 'save_signup'
  permit 'scheduler'
  
  before_filter :auth_check, :only => [ :remove, :edit ]
  
  def index
    @parties = PlannedParty.find :all, :include => :signups, :order => 'date_added desc'
    render :action => :scheduler
  end
  
  def edit
    @party = PlannedParty.find params[:id]
    render :action => :party
  end
  
  def add_request
    @party = PlannedParty.new
    render :action => :party
  end
  
  def save_party
    if params[:party][:id]
      @party = PlannedParty.find params[:party][:id]
    else
      @party = PlannedParty.new
      @party.requestor = me
    end
    @party.update_attributes params[:party]
    redirect_to :action => 'index'
  end
  
  def remove
    @party = PlannedParty.find params[:id]
    Party.transaction do
      @party.signups.each do |s| s.destroy end
      @party.destroy
    end
    redirect_to :action => 'index'
  end

  def signup
    begin
      @signup = PartySignup.find [params[:id], me.id]
    rescue
    end
    if @signup.nil?
      @signup = PartySignup.new
      @signup.party_id = params[:id]
      @signup.member_id = me.id
      @signup.sign_date = Time.now
    end
    session[:signup] = @signup
  end
  
  def save_signup
    @signup = session[:signup]
    @signup.update_attributes params[:signup]
    redirect_to :action => 'index'
  end
  
  def see_edit_ctrls(p)
    p = PlannedParty.find params[:id] unless p
    if not admin? and (p.requestor.id != me.id)
      return false
    end
    true
  end  

  private

    
  def auth_check(p=nil)
    p = PlannedParty.find params[:id] unless p
    if not admin? and (p.requestor.id != me.id)
      redirect_to :controller => 'account', :action => 'no_access'
      return false
    end
    true
  end  
end
