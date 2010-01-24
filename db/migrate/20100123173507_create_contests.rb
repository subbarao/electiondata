class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.integer :year
      t.integer :house_id
      t.string :house_type
      t.integer :votes
      t.integer :polled

      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
