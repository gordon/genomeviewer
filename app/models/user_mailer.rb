class UserMailer < ActionMailer::Base

  def password_recovery_email_to(user)
    recipients  user.email
    from        "password_recovery@genomeviewer.org"
    subject     "GenomeViewer: Your Password"
    body        :user => user
  end

  def signup_notification_to(user)
    recipients  user.email
    from        "signup_notification@genomeviewer.org"
    subject     "GenomeViewer: Thank you for registering"
    body        :user => user
  end

  def email_changed_message_to(user)
    recipients  user.email
    from        "accounts@genomeviewer.org"
    subject     "GenomeViewer: Email address changed"
    body        :user => user
  end

end
