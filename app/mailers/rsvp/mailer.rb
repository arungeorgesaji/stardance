class Rsvp::Mailer < ApplicationMailer
  def signup_confirmation(rsvp)
    @email = rsvp.email
    @confirm_code = rsvp.confirmation_token
    # The "to" address is required by Action Mailer but will be overwritten
    # by the email provided in the view. A subject is also not required here
    # as Loops will use the subject from the editor.
    mail(to: @email, from: "stardance@hackclub.com", reply_to: "rsvp@stardance.hackclub.com")
  end
end
