require "test_helper"

class Rsvp::ReplyMailboxTest < ActionMailbox::TestCase
  self.fixture_table_names = []
  self.fixture_sets = {}
  test "reply from a known RSVP stamps reply_confirmed_at" do
    rsvp = Rsvp.create!(email: "fan@example.com")
    rsvp.update_column(:reply_confirmed_at, nil)

    receive_inbound_email_from_mail \
      to: "rsvp@stardance.hackclub.com",
      from: "fan@example.com",
      subject: "Re: welcome",
      body: "Hey Stardance"

    assert_not_nil rsvp.reload.reply_confirmed_at
  end

  test "reply with mixed-case sender still matches" do
    rsvp = Rsvp.create!(email: "loud@example.com")
    rsvp.update_column(:reply_confirmed_at, nil)

    receive_inbound_email_from_mail \
      to: "rsvp@stardance.hackclub.com",
      from: "LOUD@Example.com",
      subject: "Re: welcome",
      body: "hi"

    assert_not_nil rsvp.reload.reply_confirmed_at
  end

  test "reply from an unknown sender is a no-op" do
    assert_no_difference -> { Rsvp::Reply.count } do
      assert_nothing_raised do
        receive_inbound_email_from_mail \
          to: "rsvp@stardance.hackclub.com",
          from: "stranger@example.com",
          subject: "Re: welcome",
          body: "who?"
      end
    end

    assert_nil Rsvp.find_by(email: "stranger@example.com")
  end

  test "reply from a known RSVP persists the reply contents" do
    rsvp = Rsvp.create!(email: "writer@example.com")

    assert_difference -> { rsvp.replies.count }, 1 do
      receive_inbound_email_from_mail \
        to: "rsvp@stardance.hackclub.com",
        from: "writer@example.com",
        subject: "Re: welcome",
        body: "Excited for liftoff!"
    end

    reply = rsvp.replies.last
    assert_equal "Re: welcome", reply.subject
    assert_equal "Excited for liftoff!", reply.body_text
    assert_not_nil reply.received_at
  end

  test "duplicate Message-ID does not create a second reply" do
    rsvp = Rsvp.create!(email: "dupes@example.com")
    message_id = "<unique-message-id@example.com>"

    2.times do |i|
      receive_inbound_email_from_mail \
        to: "rsvp@stardance.hackclub.com",
        from: "dupes@example.com",
        subject: "Re: welcome",
        body: "take #{i}",
        message_id: message_id
    end

    assert_equal 1, rsvp.replies.count
  end
end
