class Rsvp::Mailer < ApplicationMailer
  def signup_confirmation(rsvp)
    @email = rsvp.email
    @confirm_code = rsvp.confirmation_token
    # The "to" address is required by Action Mailer but will be overwritten
    # by the email provided in the view. A subject is also not required here
    # as Loops will use the subject from the editor.
    mail(to: @email, from: "stardance@hackclub.com", reply_to: "rsvp@stardance.hackclub.com")
  end

  def tic_tac_toe_start(game)
    @game = game
    deliver_game_email(game.rsvp.email)
  end

  def tic_tac_toe_move(game)
    @game = game
    deliver_game_email(game.rsvp.email)
  end

  def tic_tac_toe_over(game)
    @game = game
    deliver_game_email(game.rsvp.email)
  end

  def tic_tac_toe_stop(rsvp)
    @rsvp = rsvp
    deliver_game_email(rsvp.email)
  end

  private

  def deliver_game_email(to)
    mail(to: to, from: "stardance@hackclub.com", reply_to: "rsvp@stardance.hackclub.com")
  end
end
