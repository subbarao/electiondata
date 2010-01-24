class CreateDecisions < ActiveRecord::Migration
  def self.up
    create_table :decisions do |t|
      t.integer :contest_id
      t.integer :party_id
      t.integer :votes
      t.integer :contestant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :decisions
  end
end
