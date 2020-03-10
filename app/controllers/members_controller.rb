class MembersController < ApplicationController
  layout 'default'
  permit 'list'
  permit 'index'
  permit 'edit'
  permit 'update'
  
  class Post
    attr_accessor :username
  end
  
  def add
    p = params[:post]
    if p != nil
      m = Member.new
      r = Role.new
      m.transaction do
        m.username = p[:username]
        r.username = m.username
        r.role = 'member'
        m.save!
        r.save!      
        flash[:notice] = 'Succesfully added new member.'
      end
    end
    redirect_to :action => :list
  end
  
  def list
    @order = 'username'
    case params[:sort]
    when 'username' then @order='username'
    when 'username_reverse' then @order='username desc'
    end
    @members = Member.find :all, :order => @order
  end
  
  def edit
    if not admin? and params[:id].to_i != session['user'].to_i
      render '/account/no_access'
    else
      @member = Member.find params[:id]
    end
  end

  def update
    if not admin? and params[:id].to_i != session['user'].to_i
      render '/account/no_access'
      return
    end 
    @member = Member.find params[:id]
    @member.attributes = params[:member]
    if params[:member][:pass] != params[:confirm_pass]
      @member.errors.add 'Passwords', 'do not match'
      render :action => 'edit', :id => params[:id]
      return
    end
    @member.transaction do
      if me.is_admin?
        @member.update_role
      end
      @member.save!
    end
    redirect_to :action => 'list'
  end
  
  def index
    list
    render :action => 'list'
  end

  def remove
    m = Member.find(params[:id])
    r = Role.find_by_username(m.username)
    m.transaction do
      r.connection.execute "DELETE FROM roles WHERE username = '#{r.username}'"
      m.destroy
      flash[:notice] = 'Succesfully removed a member.'
    end
    redirect_to :action => 'list'
  end
end
