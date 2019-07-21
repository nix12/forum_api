class CreateVotingSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :voting_sessions do |t|
      t.string :voter_id
      t.string :post_id
      t.string :comment_id

      t.timestamps
    end
    add_index :voting_sessions, :voter_id
  end
end
