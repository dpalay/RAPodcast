class ContactMail < ActionMailer::Base
  
  def signup_notification(recipient)
    recipients recipient.email
    from "no_reply@rapodcast.net"
    subject "Welcome to RAPodcast.net"
    body :user => recipient.screen_name
  end
  
  
  def signup_confirmation_request(recipient, hash)
    # email header info MUST be added here
    recipients recipient.email
    from "no_reply@rapodcast.net"
    subject "Confirm User Registration"

    # email body substitutions go here
    body :user => recipient.screen_name, :hash => hash
  end
  
  def password_reminder(recipient)
    recipients recipient.email
    from "no_reply@rapodcast.net"
    subject "Password Reminder"
    body :user => recipient
  end
  
  def contact(emailstuff)
    recipients "dpalay@rapodcast.net", "qs23@rapodcast.net"
    from emailstuff[:from]
    cc emailstuff[:from]
    subject emailstff[:subject]
    body :content => emailstuff[:content]
  end
  
end
