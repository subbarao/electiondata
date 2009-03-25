class CreatePartyResults < ActiveRecord::Migration
  def self.up
    create_table :party_results do |t|
      t.integer :constituency_id
      t.string :name
      t.float :percentage
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :party_results
  end
end
