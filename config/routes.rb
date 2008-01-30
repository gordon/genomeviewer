ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  
  map.login 'login', 
                :controller => "login", 
                :action => "login"
  
  map.logout 'logout',
                  :controller => "in_session",
                  :action => "do_logout"

  map.registration 'registration', 
                        :controller => "register", 
                        :action => "register"
  
  map.upload 'upload',
                    :controller => "in_session", 
                    :action=> "upload"
  
  map.configuration 'configuration',
                        :controller => "in_session",
                        :action => "config"
  
  map.own_files 'files',
                      :controller => "in_session",
                      :action => "file_manager"
  
  map.public_files 'public', 
                        :controller => "public", 
                        :action => "show_users"
                        
  map.root :controller => "default"

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
