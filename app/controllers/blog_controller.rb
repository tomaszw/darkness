class BlogController < ApplicationController
  permit 'index'
  def index 
    @eqs = Eq.find_by_sql "SELECT e.* FROM eqs e, eqs_made i WHERE i.location = 'C' AND i.eq_id = e.id ORDER BY e.klass, e.points, e.sdesc"
#     :all, :include => [:party, :member, :eq_instances], :conditions =>
#      "location = 'C'" , :order => "eqs.klass, eqs.points, sdesc"
    render :action => :blog
    #redirect_to :controller => "scheduler", :action => "index"
  end
end
