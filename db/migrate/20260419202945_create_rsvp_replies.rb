class CreateRsvpReplies < ActiveRecord::Migration[8.1]
  def change
    create_table :rsvp_replies do |t|
      t.references :rsvp, null: false, foreign_key: true
      t.string :subject
      t.text :body_text
      t.text :body_html
      t.string :message_id
      t.datetime :received_at

      t.timestamps
    end

    add_index :rsvp_replies, :message_id, unique: true
  end
end
