require 'test_helper'

class RegisterControllerTest < ActionController::TestCase

  def test_register
    get :register
    assert_template "register/register"
  end

  def test_do_register
    # be sure the user wasn't already there:
    assert !User.find_by_username("test_username")
    post :do_register,
         :user => {"name"                  => "Test Name",
                   "institution"           => "Test Institute",
                   "password"              => "test_pass",
                   "password_confirmation" => "test_pass",
                   "username"              => "test_username",
                   "url"                   => "www.test-institute.edu",
                   "email"                 => "test_email@mytest.tst"}
    # test the user was really created:
    assert User.find_by_username("test_username")
  ensure
    User.find_by_username("test_username").destroy
  end

  def test_recover_password
    get :recover_password
    assert_template "register/recover_password"
  end

  def test_send_password_recovery_email_negative
    post :send_password_recovery_email, :user => {:email => "aha"}
    assert_redirected_to "register/recover_password"
    assert_not_nil flash[:errors]
  end

  def test_send_password_recovery_email_positive
    user_setup
    post :send_password_recovery_email, :user => {:email => @_u.email}
    assert_redirected_to "register/password_recovery_email_sent"
    assert_nil flash[:errors]
  end

  def test_password_recovery_email_sent
    user_setup # see test_helper
    flash = {:email => @_u.email}
    get :password_recovery_email_sent, {}, {}, flash
    assert_template "register/password_recovery_email_sent"
  end

end
