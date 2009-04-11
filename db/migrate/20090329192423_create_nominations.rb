class CreateNominations < ActiveRecord::Migration
  def self.up
    create_table :nominations do |t|
      t.string :name
      t.integer :party_id
      t.integer :seat_id
      t.string :type
      t.integer :age
      t.string :sex
      t.string :election_symbol
      t.timestamps
    end
  end

  def self.down
    drop_table :nominations
  end
end
