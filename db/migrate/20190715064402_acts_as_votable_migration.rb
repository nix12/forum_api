class ActsAsVotableMigration < ActiveRecord::Migration[4.2]
  def self.up
    create_table :votes do |t|

      t.references :votable, type: :string, :polymorphic => true
      t.references :voter, type: :string, :polymorphic => true

      t.boolean :vote_flag
      t.string :vote_scope
      t.integer :vote_weight

      t.timestamps
    end

    add_index :votes, [:voter_id, :voter_type, :vote_scope]
    add_index :votes, [:votable_id, :votable_type, :vote_scope]
  end

  def self.down
    drop_table :votes
  end
end
