# configure ActionMailer to work with sendmail

ActionMailer::Base.delivery_method = :sendmail

ActionMailer::Base.sendmail_settings = {
    :location     => '/usr/sbin/sendmail',
    :arguments    => '-i -t'
  }
