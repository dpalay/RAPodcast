ActionController::Routing::Routes.draw do |map|

  map.signup '/signup', :controller => 'users', :action => 'register'
  map.login  '/login', :controller => 'users', :action => 'login'
  map.logout '/logout', :controller => 'users', :action => 'logout'
  map.index '/index.html', :controller => 'postset', :action => 'index'
  map.donate '/donate.html', :controller => 'misc', :action => 'pax_button_donate_button'
  
  map.connect '/RAPodcastfeed.xml', :controller => 'misc', :action => 'feed'
  map.connect '/1.html', :controller => 'postset', :action => 'index'
  map.connect '/users/confirm_email/:hash', :controller => "users", :action => "confirm_email"
  
  map.connect 'tag/tag/:id.:id2', :controller => "tag", :action => "tag"
  
  map.root :controller => 'postset'
  map.connect '/tinc', :controller => "postset", :action => "index"
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  


  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format'
end
