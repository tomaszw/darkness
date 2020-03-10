class EqController < ApplicationController
  layout "default"
  permit 'index'
  permit 'list'
  
  
  def index
    list
    render :action => 'list'
  end
  
  def add
    @eq = Eq.new
  end
  
  def create
    @eq = Eq.new
    @eq.attributes=params[:eq]
    if @eq.save
      flash[:notice] = 'Item was succesfully added.'
    else
      flash[:notice] = 'Error while adding new item.'
    end
    redirect_to :action => :list
  end
  
  def list
    @eqs = Eq.find :all, :order => "mob,sdesc"
  end
  
  def edit
    @eq = Eq.find(params['id'])
  end
  
  def remove
    @eq = Eq.find(params['id'])
    @eq.destroy
    redirect_to :action => :list
  end
  
  def update
    @eq = Eq.find(params[:id])
    if @eq.update_attributes(params[:eq])
      flash[:notice] = 'Item was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end
  
end
