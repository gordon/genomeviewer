require 'test_helper'

class FormatControllerTest < ActionController::TestCase

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
    assert_template "format/list"
  end

  def test_edit_own_format
    get :edit, {:id => @_f.id}, {:user => @_u.id}
    assert_template "format/update_form"
    put :update, {:id => @_f.id,
                  "record"=>{"margins" => 10}},
                  {:user => @_u.id}
    # test if the record was updated:
    assert_equal 10, Format.find(@_f.id).margins
  end

  def test_edit_without_being_logged_in
    get :edit, :id => 1
    assert_redirected_to root_url
    put :update, {:id => @_f.id,
                  "record"=>{"margins" => 10}}
    assert_redirected_to root_url
    assert_not_equal 10, Format.find(@_f.id).margins
  end

  def test_edit_not_own_format
    get :edit, {:id => @_f.id}, {:user => @_another_u.id}
    assert_redirected_to logout_url
    post :update, {:id => @_f.id,
                  "record"=>{"margins" => 10}},
                 {:user => @_another_u.id}
    assert_redirected_to logout_url
    assert_not_equal 10, Format.find(@_f.id).margins
  end

  def test_delete_disabled
    assert_raises(ActionController::UnknownAction) do
      post :destroy, {:id => @_f.id}, {:user => @_u.id}
    end
    assert_raises(ActionController::UnknownAction) do
      get :delete, {:id => @_f.id}, {:user => @_u.id}
    end
  end

  def test_show_disabled
    assert_raises(ActionController::UnknownAction) do
      get :show, {:id => @_f.id}, {:user => @_u.id}
    end
  end

  def test_row_of_own_format
    get :row, {:id => @_f.id}, {:user => @_u.id}
    assert_template "format/_list_record"
  end

  def test_row_of_not_own_format
    get :row, {:id => @_f.id}, {:user => @_another_u.id}
    assert_redirected_to logout_url
  end

  def test_row_unlogged
    get :row, {:id => @_f.id}
    assert_redirected_to root_url
  end

end
