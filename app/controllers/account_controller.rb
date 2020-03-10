class AccountController < ApplicationController
  model   :member
  layout  'plain'
  permit 'login'
  permit 'logout'
  
  def no_access
    render :action => :no_access, :layout => 'default'
  end
  
  def login
    case @request.method
      when :post
        if user = Member.authenticate(@params['user_login'], @params['user_password'])
          @session['user'] = user.id
          @session['parties_per_page'] = 20
          #flash['notice']  = "Login successful"
          puts 'voila'
          redirect_to :controller => "scheduler", :action => "index"
        else
          @login    = @params['user_login']
          @message  = "Login unsuccessful"
      end
    end
  end
  
  def logout
    @session['user'] = nil
    reset_session
  end
end
