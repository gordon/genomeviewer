ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # named routes
  map.login 'login', 
            :controller => "default", 
            :action => "do_login"
  
  map.logout 'logout',
             :controller => "in_session",
             :action => "do_logout"

  map.registration 'registration', 
                   :controller => "register", 
                   :action => "register"
  
  map.recover_password 'recover_password',
                        :controller => "register",
                        :action => "recover_password"
  
  map.configuration 'configuration',
                    :controller => "in_session",
                    :action => "config"
  
  map.own_files 'files',
                :controller => "own_annotations",
                :action => "list"
  
  map.public_files 'public', 
                   :controller => "public_annotations"
                        
  map.root :controller => "default"
  
  # connect controllers
  
  map.connect 'default/:action',
              :controller => "default"
  map.connect 'in_session/:action',
              :controller => "in_session"
  map.connect 'own_annotations/:action',
              :controller => "own_annotations"
  map.connect 'public_annotations/:action',
              :controller => "public_annotations"
  map.connect 'public_users/:action',
              :controller => "public_users"
  map.connect 'register/:action',
              :controller => "register"
  
  # all other URLs are interpreted as viewer URLs
  map.image 'image/:username/:annotation/:seq_region/:start_pos/:end_pos',
              :action => "image",
              :controller => "viewer",
              :annotation => /[^\/]+\.?[^\/]*/,
              :seq_region => nil,
              :start_pos => nil,
              :end_pos => nil 
              
 map.move 'move/:username/:annotation/:seq_region/:start_pos/:end_pos',
              :action => "ajax_movement",
              :controller => "viewer",
              :annotation => /[^\/]+\.?[^\/]*/,
              :seq_region => nil,
              :start_pos => nil,
              :end_pos => nil 

  # in order to allow this to work some restrictions on username must be valid (e.g. can't be "image")
  # in User model there is a list of invalid names
  map.view ':username/:annotation/:seq_region/:start_pos/:end_pos',
              :controller => "viewer",
              :action => "index",
              :annotation => /[^\/]+\.?[^\/]*/,
              :seq_region => nil,
              :start_pos => nil,
              :end_pos => nil 

end
