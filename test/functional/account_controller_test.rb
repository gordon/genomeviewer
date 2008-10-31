require 'test_helper'

class AccountControllerTest < ActionController::TestCase

  fixtures 'users'

  def setup
    @u = users('a_test')
    # session:
    @in = {:user => @u.id}
    @out = {}
    UserMailer.delivery_method = :test
    UserMailer.deliveries = []
  end

  %w[ index
      email        update_email
      password     update_password
      public_data  update_public_data
    ].each do |a|
    define_method "test_#{a}_unlogged" do
      get :update_public_data, {}, @out
      assert_redirected_to root_url
    end
  end

  %w[index email password public_data].each do |a|
    define_method "test_#{a}_get" do
      get a, {}, @in
      assert_response :success
      assert_template "account/#{a}"
    end
  end

  %w[email password public_data].each do |a|
    define_method "test_update_#{a}_get" do
      get :"update_#{a}", {}, @in
      assert_redirected_to :action => a
    end
  end

  def test_index_menu
    get :index, {}, @in
    # follow links:
    css_select('#main a').each do |a|
      get URI(a['href']).path[1..-1] # path without root
      assert_response :success
    end
  end

  def test_update_name_invalid
    @request.env["HTTP_REFERER"] = '/account/public_data'
    par = {:current_user => {'name' => ''}}
    post :update_public_data, par, @in
    assert_template 'account/public_data'
    assert assigns(:current_user).errors.on(:name)
    assert_equal '', assigns(:current_user).name
    assert_not_equal '', User.find(session[:user]).name
  end

  def test_update_name_valid
    assert_not_equal 'Another Name', @u.name
    par = {:current_user => {'name' => 'Another Name'}}
    post :update_public_data, par, @in
    assert_redirected_to account_url
    assert_equal 'Another Name', User.find(session[:user]).name
  end

  def test_update_public_data
    pars = []
    pars[0] = {'name'        => 'Another Name',
               'institution' => 'Example Institution',
               'url'         => 'http://example.com'}
    pars[1] = {'name'        => 'Another Name',
               'institution' => '',
               'url'         => 'http://example.com'}
    pars[2] = {'name'        => 'Another Name',
               'institution' => 'Example Institution',
               'url'         => ''}
    pars.each do |par|
      post :update_public_data, {:current_user => par}, @in
      assert_redirected_to account_url # it worked
      par.each_pair do |attribute, value|
        assert_equal value, assigns(:current_user).send(attribute)
        assert_equal value, User.find(session[:user]).send(attribute)
      end
    end
  end

  def test_update_email_unchanged
    post :update_email, {:current_user => {:email => @u.email}}, @in
    assert_nil assigns(:current_user).errors.on(:email)
    assert_equal 0, UserMailer.deliveries.size
    assert_redirected_to account_url
  end

  def test_update_email_blank
    post :update_email, {:current_user => {:email => ''}}, @in
    assert_not_nil assigns(:current_user).errors.on(:email)
    assert_equal 0, UserMailer.deliveries.size
    assert_template 'account/email'
  end

  def test_update_email_invalid
    post :update_email, {:current_user => {:email => '#+*?!'}}, @in
    assert_not_nil assigns(:current_user).errors.on(:email)
    assert_equal 0, UserMailer.deliveries.size
    assert_template 'account/email'
  end

  def test_update_email_valid
    post :update_email, {:current_user => {:email => 'a@b.cd'}}, @in
    assert_nil assigns(:current_user).errors.on(:email)
    assert_equal 1, UserMailer.deliveries.size
    assert_redirected_to account_url
  end

  def test_update_password_old_wrong
    par = {:old => '', :new => '', :confirm => ''}

    post :update_password, par, @in
    assert_redirected_to logout_url

    post :update_password, par, @in.merge(:tries => 1)
    assert_redirected_to :action => :password
    assert_equal 2, session[:tries]

    post :update_password, par, @in.merge(:tries => 4)
    assert_redirected_to logout_url
  end

  def test_update_password_confirmation_failure
    par = {:old => @u.password, :new => 'abcd', :confirm => 'bcde'}
    post :update_password, par, @in
    assert_not_nil flash[:errors]
    assert_redirected_to :action => :password
  end

  def test_update_password_invalid
    par = {:old => @u.password, :new => '', :confirm => ''}
    post :update_password, par, @in
    assert_not_nil flash[:errors]
    assert_redirected_to :action => :password
    assert_not_nil assigns(:current_user).errors[:password]
  end

  def test_update_password_valid
    par = {:old => @u.password, :new => 'abcd', :confirm => 'abcd'}
    post :update_password, par, @in
    assert_nil flash[:errors]
    assert_not_nil flash[:info]
    assert_redirected_to account_url
    assert_equal 'abcd', User.find(session[:user]).password
  end

end
