class CreateCandidateResults < ActiveRecord::Migration
  def self.up
    create_table :candidate_results do |t|
      t.integer :constituency_id
      t.integer :year
      t.integer :total_votes,:limit => 14
      t.float :turnout
      t.string :winner
      t.string :winning_party
      t.float :winning_percentage
      t.string :runnerup
      t.string :runnerup_party
      t.float :runnerup_percentage
      t.timestamps
    end
  end

  def self.down
    drop_table :candidate_results
  end
end
