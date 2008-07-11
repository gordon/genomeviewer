require File.dirname(__FILE__) + '/../test_helper'

class PasswordRecoveryTest < ActionMailer::TestCase
  tests PasswordRecovery
  
  def test_email_delivery
    assert_no_emails
    PasswordRecovery.deliver_password_recovery_email_to(user_for_testing)
    assert_emails 1
  end
  
  def user_for_testing
    @user ||= User.create(:name => "Test Person",
                                     :email => "test@test.test",
                                     :password => "test")
  end
  
end
