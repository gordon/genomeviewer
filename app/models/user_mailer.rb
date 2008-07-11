class UserMailer < ActionMailer::Base
  
  def password_recovery_email_to(user)
    recipients  user.email
    from        "password_recovery@genomeviewer.org"
    subject     "Genomeviewer: Your Password"
    body        :user => user
  end

  def signup_notification_to(user)
    recipients  user.email
    from        "signup_notification@genomeviewer.org"
    subject     "Genomeviewer: Thank you for registering"
    body        :user => user
  end

end
