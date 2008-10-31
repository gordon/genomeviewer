require 'test_helper'

class PublicAnnotationsControllerTest < ActionController::TestCase

  def setup
    assert user_setup # see test_helper
    assert !@_a.public # @_a is private, make it public with
                       # an update_attributes where desired
  end

  def test_list_logged_in
    get :index, {}, {:user => @_u.id}
    assert_template "public_annotations/list"
  end

  def test_list_not_logged_in
    get :index, {}, {}
    # works anyway, as this is the public controller
    assert_template "public_annotations/list"
  end

  def test_show_disabled
    @_a.update_attributes(:public => true)
    assert_raises(ActionController::UnknownAction) do
      get :show, {:id => @_a.id}, {}
    end
  end

  def test_delete_disabled
    @_a.update_attributes(:public => true)
    assert_raises(ActionController::UnknownAction) do
      post :destroy, {:id => @_a.id}, {}
    end
    assert_raises(ActionController::UnknownAction) do
      get :delete, {:id => @_a.id}, {}
    end
  end

  def test_edit_disabled
    @_a.update_attributes(:public => true)
    assert_raises(ActionController::UnknownAction) do
      post :edit, {:id => @_a.id}, {}
    end
    assert_raises(ActionController::UnknownAction) do
      post :update, {:id => @_a.id}, {}
    end
  end

  def test_create_disabled
    assert_raises(ActionController::UnknownAction) do
      post :new, {}, {}
    end
    assert_raises(ActionController::UnknownAction) do
      post :create, {}, {}
    end
  end

  def test_row_of_public_annotation
    @_a.update_attributes(:public => true)
    get :row, {:id => @_a.id}
    assert_template "public_annotations/_list_record"
  end

  def test_row_of_private_annotation
    get :row, {:id => @_a.id}
    assert_redirected_to root_url
  end

  def test_open_public_annotation
    @_a.update_attributes(:public => true)
    get :open, {:id => @_a.id}, {:user => @_u.id}
    assert_redirected_to :controller => :viewer,
                         :annotation => @_a.name,
                         :username => @_u.username
  end

  def test_open_private_annotation
    get :open, {:id => @_a.id}, {:user => @_u.id}
    assert_redirected_to root_url
  end

end
