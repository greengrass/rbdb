class AccountsController < ApplicationController
  
  skip_before_filter :authenticate, :only => [:login]
  
  def login
    if request.post?
      if do_login
        redirect_to session[:return_to] || '/databs'
       end
    end
  end
  
  def logout
    reset_session
    flash[:error] = 'You were logged out'
    redirect_to :action => 'login'
  end
end