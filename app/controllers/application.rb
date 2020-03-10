# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  layout 'default'
  
  @@permits = {}
  def self.permit(action)
    @@permits[self] = [] if @@permits[self].nil?
    @@permits[self] << action
  end
  
  before_filter :authenticate,
  :authorize,
  :except => [:login, :logout, :no_access]
 
  after_filter :after
   
  def me
    Member.find session['user']
  end
  
#  def url_for(options = {}, *pms)
#    url= super(options, *pms)
#    if url[-6,6] == '/index' then url = url[0,url.length-6] end
#    url
#  end
  
  def admin?
    return @session[:admin] if @session[:admin] != nil
    @session[:admin] = me.is_admin?
    @session[:admin]
  end
  
  def authenticate
    puts @request
    unless session['user']
      redirect_to :controller => "account", :action => "login"
      return false
    end
  end
  
  def authorize
    return false if not session['user']
    unless me.is_admin?
      puts 'trying to authorize ' + session['user'].to_s + ' for action '+  action_name
      unless @@permits[self.class] != nil and @@permits[self.class].include? action_name
        puts '...failed'
        redirect_to :controller => 'account', :action => 'no_access'
        return false  
      end
      puts 'success'
    end
  end
  
  def after
    session[:back] = url_for :action => action_name
  end
  
  
end