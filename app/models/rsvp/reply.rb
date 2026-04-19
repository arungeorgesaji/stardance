# == Schema Information
#
# Table name: rsvp_replies
#
#  id          :bigint           not null, primary key
#  body_html   :text
#  body_text   :text
#  received_at :datetime
#  subject     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  message_id  :string
#  rsvp_id     :bigint           not null
#
# Indexes
#
#  index_rsvp_replies_on_message_id  (message_id) UNIQUE
#  index_rsvp_replies_on_rsvp_id     (rsvp_id)
#
# Foreign Keys
#
#  fk_rails_...  (rsvp_id => rsvps.id)
#
class Rsvp::Reply < ApplicationRecord
  self.table_name = "rsvp_replies"

  belongs_to :rsvp

  validates :message_id, uniqueness: true, allow_nil: true
end
