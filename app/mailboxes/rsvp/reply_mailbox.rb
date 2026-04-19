class Rsvp::ReplyMailbox < ApplicationMailbox
  def process
    sender = mail.from.first.to_s.downcase.strip
    rsvp = Rsvp.find_by(email: sender)
    return unless rsvp

    rsvp.confirm_reply!
    persist_reply(rsvp)
  end

  private

  def persist_reply(rsvp)
    rsvp.replies.find_or_create_by!(message_id: mail.message_id) do |reply|
      reply.subject     = mail.subject
      reply.body_text   = extract_text_body
      reply.body_html   = mail.html_part&.body&.decoded
      reply.received_at = mail.date || Time.current
    end
  end

  def extract_text_body
    return mail.text_part.body.decoded if mail.text_part
    return nil if mail.multipart?

    mail.body.decoded
  end
end
