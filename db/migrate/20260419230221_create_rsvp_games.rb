class CreateRsvpGames < ActiveRecord::Migration[8.1]
  def change
    create_table :rsvp_games do |t|
      t.references :rsvp, null: false, foreign_key: true
      t.string  :board, null: false, default: "---------"
      t.integer :status, null: false, default: 0
      t.integer :move_count, null: false, default: 0
      t.timestamps
    end
    add_index :rsvp_games, [ :rsvp_id, :status ]
  end
end
