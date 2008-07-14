require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer
  
  def test_password_recovery
    assert_no_emails
    UserMailer.deliver_password_recovery_email_to(user_for_testing)
    assert_emails 1
  end
  
  def test_signup_notification
    assert_no_emails
    UserMailer.deliver_signup_notification_to(user_for_testing)
    assert_emails 1
  end
  
  def test_email_change
    assert_no_emails
    UserMailer.deliver_email_changed_message_to(user_for_testing)
    assert_emails 1
  end
  
  def user_for_testing
    @user ||= User.create(:name => "Test Person",
                                     :email => "test@test.test",
                                     :password => "test")
  end
  
end
