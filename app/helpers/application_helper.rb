# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    include TagsHelper
  
  def current_user
    User.find(session[:user_id])
  end
  
  def logged_in?
    not session[:user_id].nil?
  end
  
  def admin?
    if logged_in?
      current_user.is_admin
    else
      false
    end
  end
  
  def confirmation_hash(string)
    Digest::SHA1.hexdigest(string + "rapodcast is absolutely amazing")
  end
  
  def protect
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "You must log in first"
      redirect_to :controller => :users, :action => :login
      return false
    end
  end
  
  def protect_admin
    unless admin?
      flash[:warning] = "You just attempted to perform an unauthorized action!"
      redirect_to :controller => :postset, :action => :index
    end
  end
  
end
