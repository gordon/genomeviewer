#
# if you change the routing, remember to update the list 
# of invalid usernames (in config/invalid_usernames.yml)
# in order to keep the /:username routing valid
#
ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # named routes
  map.login 'login', 
            :controller => "default", 
            :action => "do_login"
  
  map.logout 'logout',
             :controller => "default",
             :action => "do_logout"

  map.registration 'registration', 
                   :controller => "register", 
                   :action => "register"
  
  map.recover_password 'recover_password',
                        :controller => "register",
                        :action => "recover_password"
  
  map.configuration 'configuration',
                    :controller => "configuration"
                    
  map.account 'account',
              :controller => "account"
              
  map.own_files 'my_files',
                :controller => "own_annotations",
                :action => "list"
  
  map.public_files 'files', 
                   :controller => "public_annotations"
                        
  map.root :controller => "default"
  
  # connect controllers
  
  controllers = 
      %w[account 
         configuration 
         default 
         feature_types
         format
         own_annotations 
         public_annotations 
         public_users 
         register 
         viewer]
  
  controllers.each do |controller_name|
    map.connect "#{controller_name}/:action",
               :controller => controller_name
  end
  
  # user public page
  
  map.connect ':username',
              :controller => 'public_annotations',
              :action => 'user'
  
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
