require 'test_helper'

class DefaultControllerTest < ActionController::TestCase
  
  fixtures 'users'

  def setup
    @u = users('a_test')
    @login_params = {:user => {:username => @u.username, 
                               :password => @u.password}}
    # session hash:
    @in = {:user => @u.id}
    @out = {}
  end
  
  ### tests of code in ApplicationController ###
  
  def test_get_current_user
    get :index, {}, @out
    assert_nil assigns(:current_user)
    get :index, {}, @in
    assert_equal @u, assigns(:current_user)
  end
  
  def test_enforce_login
    # this is simplier to be indirectly tested
    # through its effects
  end
  
  ### tests specific of DefaultController ###
  
  def test_homepage
    get :index
    assert_response :success
    assert_template "default/index"
  end
  
  def test_do_login
    get :index
    assert_nil assigns(:current_user)
    post :do_login, @login_params
    get :index
    assert_equal @u, assigns(:current_user)
  end
  
  def test_do_logout
    post :do_login, @login_params
    get :index
    assert_equal @u, assigns(:current_user)
    get :do_logout
    get :index
    assert_nil assigns(:current_user)
  end
  
end
