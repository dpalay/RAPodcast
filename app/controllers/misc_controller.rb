class MiscController < ApplicationController


  def about_us
  end

  def contact_us
end

  def check_this_out
    
  end
  
  def send_mail  
  end

  def why_sign_up
  end

  def site_history
  end
  
  def feed
  	render :action => "misc/rapodcastfeed", :layout => false
  end
  
  def rapodcastfeed
  end

  def pax_button_donate_button
    @title = "PAX Button Case Donation Page"
  end

end
