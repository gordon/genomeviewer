class UserMailer < ActionMailer::Base

  def password_recovery_email_to(user)
    recipients  user.email
    from        "support@genomeviewer.org"
    subject     "GenomeViewer: Your reminder"
    body        :user => user
  end

  def signup_notification_to(user)
    recipients  user.email
    from        "support@genomeviewer.org"
    subject     "GenomeViewer: Thank you for registering"
    body        :user => user
  end

  def email_changed_message_to(user)
    recipients  user.email
    from        "support@genomeviewer.org"
    subject     "GenomeViewer: Email address changed"
    body        :user => user
  end

end
