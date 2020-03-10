class TransfersController < ApplicationController
  permit 'index'
  permit 'realize'
  
  def index
    @transfers = Transfer.find :all, :order => "stamp desc"
    @members = Member.find :all, :order => :username
    @members.delete me
    @members = @members.map {|m| [ m.Username, m.id] }
    render :action => :list
  end
  
  def realize
    post = params[:post]
    unless post.nil?
      from = me
      to = Member.find post[:to]
      amount = post[:amount].to_i
      avail_pts = me.pool_points
      if amount > avail_pts
        flash[:notice] = "You lack points to complete transfer to #{to.Username}."
        redirect_to :action => :index
        return
      end
      if amount < 1
        flash[:notice] = 'Can only transfer positive amount of points.'
        redirect_to :action => :index
        return
      end
      t = Transfer.new
      t.member_from = me
      t.member_to = to
      t.amount = amount
      t.stamp = Time.now
      if t.save
        flash[:notice] = 'Transfer succesfull!'
      else
        flash[:notice] = 'Error performing the transfer.'
      end
      redirect_to :action => :index
    end
  end
end
