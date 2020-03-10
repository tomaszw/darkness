class EqLocatorController < ApplicationController
  permit 'index'
  permit 'list'
  
  auto_complete_for :member, :username

  class Post
    attr_accessor :move_location, :location, :name_on_eq, :sdesc
  end
  
  def initialize
    @order = nil
    @party = nil
    @name  = nil
    @location = nil
    @location_ply = nil
  end
  
  def move
    eq_ids = []
    for k in params.keys
      if k =~ /^cb_(\d+)/
        eq_ids << $1.to_i
      end
    end  
    
    eq = eq_ids.map { |id| EqInstance.find id }
    loc = params[:post][:move_location]
    tgt_loc = nil
    tgt_ply = nil
    if loc == '@chest'
      tgt_loc = 'C'
    elsif loc == '@sold'
      tgt_loc = 'S'
    elsif loc == '@hidden'
      tgt_loc = 'H'
    else
      tgt_loc = 'P'
      tgt_ply = member_by_name(loc)
    end
    
    me.transaction do
      eq.each do |inst|
        inst.location = tgt_loc
        inst.member = tgt_ply
        inst.save!
      end
    end
    
    redirect_to :action => :list
  end
  
  def index
    list
    render :action => :list
  end
  
  def parse_params
    @party = nil
    @location = "C"
    @location_ply = nil
    @order = nil
    
    if params['party']
      @party = Party.find params['party']
    end
    case params['location']
    when 'chest'
      @location = 'C'
      @location_ply = nil
    when 'sold'
      @location = 'S'
      @location_ply = nil
    when 'hidden'
      @location = 'H'
      @location_ply = nil
    else
      if params['location']
        @location = 'P'
        @location_ply = Member.find_by_username params['location'].downcase
      end
    end
    
    case params['sort']
      when 'sdesc' then @order = "sdesc"
      when 'sdesc_reverse' then @order = "sdesc desc"
      when 'stats' then @order = "stats"
      when 'stats_reverse' then @order = 'stats desc'
      when 'value' then @order = "points"
      when 'value_reverse' then @order = 'points desc'
      when 'location' then @order = 'location, username'
      when 'location_reverse' then @order = 'location desc, username desc'
    end      
  end
  
  def search
  end
  
  def list
    @post = Post.new
    if params[:post]
      @post.location = params[:post][:location]
      @post.name_on_eq = params[:post][:name_on_eq]
      @post.sdesc = params[:post][:sdesc]
    end
    @post.location = '@chest' if @post.location.nil?
    @list_of_locations = []
    @name_options = [['','']]
    lol = @list_of_locations
    lol << ['@anywhere', '@anywhere']
    lol << ['@chest', '@chest']
    lol << ['@sold', '@sold']
    lol << ['@hidden', '@hidden']
    (Member.find :all, :order => :username).each do |m|
      lol << ['@'+m.Username, '@'+m.Username]
      @name_options << [m.Username, m.Username]
    end

    @conditions = ["true"]
    @pms = []
    
    if @post.sdesc and @post.sdesc != ''
      @conditions << "sdesc like '%%%s%%'"
      @pms << @post.sdesc
    end
    
    case @post.location
    when '@chest'
      @conditions << "location = 'C'"
    when '@hidden'
      @conditions << "location = 'H'"
    when '@sold'
      @conditions << "location = 'S'"
    when '@anywhere'
    else
      @conditions << "location = 'P' and member_id = ?"
      @pms << member_by_name(@post.location).id
    end
    
    c = @conditions.join(" and ")  
    @eq_instances = EqInstance.find :all, :include => [:party, :member, :eq], :conditions => [c, @pms], :order => 'sdesc'
  end
  
  protected
  
  def member_by_name(name)
    if name[0..0] == '@' 
      name = name[1..name.length]
    end
    name = name.downcase
    Member.find :first, :conditions => ['lower(username) = ?', name]
  end
end