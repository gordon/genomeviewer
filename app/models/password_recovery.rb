class PasswordRecovery < ActionMailer::Base
  
  def password_recovery_email_to(user)
    recipients  user.email
    from        "password_recovery@genomeviewer.org"
    subject     "Genomeviewer: Your Password"
    body        :user => user
  end

end
