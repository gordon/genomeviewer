require 'test_helper'

class OwnAnnotationsControllerTest < ActionController::TestCase

  fixtures 'users'

  def setup
    assert user_setup # see test_helper
    @_another_u = users('a_test')
    @_another_u.configuration = Configuration.new
  end

  def test_unlogged_access_refused
    %w[index list edit destroy show new show_search table row].each do |x|
      get x
      assert_redirected_to root_url
    end
  end

  def test_list_logged_in
    get :index, {}, {:user => @_u.id}
    assert_template "own_annotations/list"
  end

  def test_edit_own_annotation
    get :edit, {:id => @_a.id}, {:user => @_u.id}
    assert_template "own_annotations/update_form"
    put :update, {:id => @_a.id,
                  "record"=>{"description"=>"_test_2"}},
                  {:user => @_u.id}
    # test if the record was updated:
    assert_equal "_test_2", Annotation.find(@_a.id).description
  end

  def test_upload_on_own_account
    flunk #TODO: write this test
  end

  def test_upload_unlogged
    flunk #TODO: write this test
  end

  def test_upload_on_not_own_account
    flunk #TODO: write this test
  end

  def test_edit_without_being_logged_in
    get :edit, :id => 1
    assert_redirected_to root_url
    put :update, {:id => @_a.id,
                  "record"=>{"description"=>"_test_2"}}
    assert_redirected_to root_url
    assert_not_equal "_test_2", Annotation.find(@_a.id).description
  end

  def test_edit_not_own_annotation
    get :edit, {:id => @_a.id}, {:user => @_another_u.id}
    assert_redirected_to logout_url
    post :update, {:id => @_a.id,
                  "record"=>{"description"=>"_test_2"}},
                 {:user => @_another_u.id}
    assert_redirected_to logout_url
    assert_not_equal "_test_2", Annotation.find(@_a.id).description
  end

  def test_delete_own_annotation
    post :delete, {:id => @_a.id}, {:user => @_u.id}
    assert_template "own_annotations/delete"
    post :destroy, {:id => @_a.id}, {:user => @_u.id}
    # test if the record was deleted:
    assert_raises(ActiveRecord::RecordNotFound) {Annotation.find(@_a.id)}
  end

  def test_delete_not_own_annotation
    post :delete, {:id => @_a.id}, {:user => @_another_u.id}
    assert_redirected_to logout_url
    post :destroy, {:id => @_a.id}, {:user => @_another_u.id}
    # the record should still be there:
    assert Annotation.find(@_a.id)
  end

  def test_delete_not_logged_in
    post :delete, {:id => @_a.id}
    assert_redirected_to root_url
    post :destroy, {:id => @_a.id}
    # the record should still be there:
    assert Annotation.find(@_a.id)
  end

  def test_show_disabled
    assert_raises(ActionController::UnknownAction) do
      get :show, {:id => @_a.id}, {:user => @_u.id}
    end
  end

  def test_row_of_own_annotation
    get :row, {:id => @_a.id}, {:user => @_u.id}
    assert_template "own_annotations/_list_record"
  end

  def test_row_of_not_own_annotation
    get :row, {:id => @_a.id}, {:user => @_another_u.id}
    assert_redirected_to logout_url
  end

  def test_row_unlogged
    get :row, {:id => @_a.id}
    assert_redirected_to root_url
  end

  def test_open_own_annotation
    get :open, {:id => @_a.id}, {:user => @_u.id}
    assert_redirected_to :controller => :viewer,
                         :annotation => @_a.name,
                         :username => @_u.username
  end

  def test_open_annotation_unlogged
    get :open, {:id => @_a.id}
    assert_redirected_to root_url
  end

  def test_open_not_own_annotation
    get :open, {:id => @_a.id}, {:user => @_another_u.id}
    assert_redirected_to logout_url
  end

  def test_file_access_control_on_own
    post :file_access_control,
         {:id => @_a.id},
         {:user => @_u.id}
    assert_response :success
  end

  def test_file_access_control_unlogged
    post :file_access_control,
         {:id => @_a.id}
    assert_redirected_to root_url
  end

  def test_file_access_control_on_not_own
    post :file_access_control,
         {:id => @_a.id},
         {:user => @_another_u.id}
    assert_redirected_to logout_url
  end

end
