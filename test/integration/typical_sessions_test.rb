require 'test_helper'

class TypicalSessionsTest < ActionController::IntegrationTest
  
  # open main page
  # have a look in the public files list
  # have a look in the public users list
  # register an account
  # logout
  def test_user_registration
    get root_url
    assert_template "default/index"
    get "files"
    assert_template "public_annotations/list"
    # no public annotations:
    assert_select ".active-scaffold-found", /0./
    get "public_users"
    assert_template "public_users/list"
    # no users with public annotations:
    assert_select ".active-scaffold-found", /0./
    get "registration"
    assert_template "register/register"
    post_via_redirect "register/do_register", 
      {"user"=>{"name"                  => "Test Name", 
                "institution"           => "Test Institute", 
                "password"              => "test_pass", 
                "password_confirmation" => "test_pass", 
                "username"              => "test_username", 
                "url"                   => "www.test-institute.edu", 
                "email"                 => "test_email@mytest.tst"}}
    assert_template "own_annotations/list"
    # no annotations:
    assert_select ".active-scaffold-found", /0./
    get "logout"
    assert_redirected_to root_url
  end
  
  def teardown
    # delete registered user: 
    User.find_by_username("test_username").destroy
  end
  
  
end
