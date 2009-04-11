class CreateSeats < ActiveRecord::Migration
  def self.up
    create_table :seats do |t|
      t.string :name
      t.integer :district_id
      t.float :lat
      t.float :lng
      t.float :distance
      t.string :locality
      t.string :type
      t.integer :phase
      t.date :election_date
      t.timestamps
    end
  end

  def self.down
    drop_table :seats
  end
end
