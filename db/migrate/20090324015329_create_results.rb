class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.string :name
      t.integer :party_id
      t.integer :constituency_id
      t.integer :votes,:limit => 12
      t.float :percentage
      t.integer :year
      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
