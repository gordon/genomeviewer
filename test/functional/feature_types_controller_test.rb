require 'test_helper'

class FeatureTypesControllerTest < ActionController::TestCase
  
  fixtures 'users'
    
  def setup
    @u = users('a_test')
    @u.configuration = Configuration.new
    # session:
    @in = {:user => @u.id}
    @out = {}
  end
  
  def test_unlogged_access_refused
    %w[index list edit destroy show new show_search].each do |x|
      get x, {}, @out
      assert_redirected_to root_url
    end
  end
  
  def test_logged_in_access
    get :index, {}, @in
    assert_template "feature_types/list"
  end
  
  def test_edit_without_being_logged_in
    assert user_setup
    get :edit, :id => 1
    assert_redirected_to root_url
  end
  
  def test_edit_ft_of_another_user
    assert user_setup
    assert @_ft.configuration.user != @u
    get :edit, {:id => @_ft.id}, {:user => @u.id}
    #
    # |--- security hole ---|
    #
    assert_redirected_to root_url # this fails
  end
  
  def test_edit_own_feature_type
    assert user_setup
    assert @_ft.configuration.user == @_u
    get :edit, {:id => @_ft.id}, {:user => @_u.id}
    assert_template "feature_types/update_form"
  end
  
end
