require 'test_helper'

class FeatureTypesControllerTest < ActionController::TestCase
  
  fixtures 'users'
    
  def setup
    assert user_setup # see test_helper
    @_another_u = users('a_test')
    @_another_u.configuration = Configuration.new
  end
  
  def test_unlogged_access_refused
    %w[index list edit destroy show new show_search].each do |x|
      get x
      assert_redirected_to root_url
    end
  end
  
  def test_list_logged_in
    get :index, {}, {:user => @_u.id}
    assert_template "feature_types/list"
  end
  
  def test_edit_own_feature_type
    get :edit, {:id => @_ft.id}, {:user => @_u.id}
    assert_template "feature_types/update_form"
    put :update, {:id => @_ft.id,
                  "record"=>{"name"=>"_test_2"}}, 
                  {:user => @_u.id}
    # test if the record was updated:
    assert_equal "_test_2", FeatureType.find(@_ft.id).name
  end
  
  def test_edit_without_being_logged_in
    get :edit, :id => 1
    assert_redirected_to root_url
    put :update, {:id => @_ft.id,
                  "record"=>{"name"=>"_test_2"}}
    assert_redirected_to root_url
    assert_not_equal "_test_2", FeatureType.find(@_ft.id).name
  end
  
  def test_edit_not_own_feature_type
    get :edit, {:id => @_ft.id}, {:user => @_another_u.id}
    assert_redirected_to logout_url
    post :update, {:id => @_ft.id,
                  "record"=>{"name"=>"_test_2"}}, 
                 {:user => @_another_u.id}
    assert_redirected_to logout_url
    assert_not_equal "_test_2", FeatureType.find(@_ft.id).name
  end
  
  def test_delete_own_feature_type
    post :delete, {:id => @_ft.id}, {:user => @_u.id}
    assert_template "feature_types/delete"
    post :destroy, {:id => @_ft.id}, {:user => @_u.id}
    # test if the record was deleted:
    assert_raises(ActiveRecord::RecordNotFound) {FeatureType.find(@_ft.id)}
  end
  
  def test_delete_not_own_feature_type
    post :delete, {:id => @_ft.id}, {:user => @_another_u.id}
    assert_redirected_to logout_url
    post :destroy, {:id => @_ft.id}, {:user => @_another_u.id}
    # the record should still be there:
    assert FeatureType.find(@_ft.id)
  end
  
  def test_delete_not_logged_in
    post :delete, {:id => @_ft.id}
    assert_redirected_to root_url
    post :destroy, {:id => @_ft.id}
    # the record should still be there:
    assert FeatureType.find(@_ft.id)
  end
  
  def test_show_own_feature_type
    get :show, {:id => @_ft.id}, {:user => @_u.id}
    assert_template "feature_types/show"
  end
  
  def test_show_not_own_feature_type
    get :show, {:id => @_ft.id}, {:user => @_another_u.id}
    assert_redirected_to logout_url
  end
  
  def test_show_not_logged_in
    get :show, {:id => @_ft.id}
    assert_redirected_to root_url
  end
  
end
