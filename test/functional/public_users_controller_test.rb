require File.dirname(__FILE__) + '/../test_helper'

class PublicUsersControllerTest < ActionController::TestCase

  def setup
    assert user_setup # see test_helper
    # @_u is private
    assert @_u.public_annotations_count == 0
  end

  # @_u has no public annotations (i.e. is a private user),
  # make @_a public and update the count where
  # you need it to be a public user
  def user_goes_public
    @_a.update_attributes(:public => true)
    @_u.update_attributes(:public_annotations_count => 1)
  end

  def test_list_logged_in
    get :index, {}, {:user => @_u.id}
    assert_template "public_users/list"
  end

  def test_list_not_logged_in
    get :index, {}, {}
    # works anyway, as this is a public controller
    assert_template "public_users/list"
  end

  def test_show_disabled
    user_goes_public
    assert_raises(ActionController::UnknownAction) do
      get :show, {:id => @_u.id}, {}
    end
  end

  def test_delete_disabled
    user_goes_public
    assert_raises(ActionController::UnknownAction) do
      post :destroy, {:id => @_u.id}, {}
    end
    assert_raises(ActionController::UnknownAction) do
      get :delete, {:id => @_u.id}, {}
    end
  end

  def test_edit_disabled
    user_goes_public
    assert_raises(ActionController::UnknownAction) do
      post :edit, {:id => @_u.id}, {}
    end
    assert_raises(ActionController::UnknownAction) do
      post :update, {:id => @_u.id}, {}
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

  def test_row_of_public_user
    user_goes_public
    get :row, {:id => @_u.id}
    assert_template "public_users/_list_record"
  end

  def test_row_of_private_user
    get :row, {:id => @_u.id}
    assert_redirected_to root_url
  end

end
