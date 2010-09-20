# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  #filters to be run on every controller
  before_filter :check_authorization

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_rapodcast_session_id'
  
  # Check for authorization Cookie, possibly logging the user in
  def check_authorization
    authorization_token = cookies[:authorization_token]
    if authorization_token and not logged_in?
      user = User.find_by_authorization_token(authorization_token)
      user.login!(session) if user
    end
  end
  
  private
  def get_newest_links
    @link = Link.find_by_id('-1')
  end
  
  def get_newest_postset
    if Postset.find(:all).last.published == true
      Postset.find(:all).last
    else
      Postset.find(:all, :conditions => [ "id < ?", Postset.find(:all).last.id]).last
    end    
  end
  
  
    
end

