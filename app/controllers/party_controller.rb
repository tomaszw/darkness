class PartyController < ApplicationController
  permit 'index'
  permit 'list'
  permit 'change_per_page'
  permit 'detail'
  
  def list
    pp = @session[:parties_per_page]
    pp = 20 if pp.nil?
    pp = pp.to_i
    pp = 1 if pp<1
    @per_page = pp
    @party_pages, @parties = paginate :parties, :order => "partydate desc, id desc", :per_page => @per_page
  end
 
  def change_per_page
    if params[:per_page] != nil
      @session[:parties_per_page] = params[:per_page].to_i
    end
    redirect_to :action => :list
  end
   
  def add
    p = Party.new
    p.partydate = Date.today
    p.save!
    redirect_to :action => :list
  end
  
  def remove
    p = Party.find @params[:id]
    p.destroy unless p.nil?
    redirect_to :action => :list
  end
  
  def edit
    redirect_to :controller => 'party_editor', :id => params[:id]
    #render_text params[:id]
  end
  
  def detail
    @party = Party.find params[:id]
    @members = @party.party_members.find(:all, :include => :member, :order => "username")
    @eqs = @party.eq_instances.find(:all, :include => :eq, :order => "sdesc")
  end
  
end
