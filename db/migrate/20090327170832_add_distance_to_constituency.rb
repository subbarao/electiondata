class AddDistanceToConstituency < ActiveRecord::Migration
  def self.up
    add_column :constituencies,:distance,:float
  end

  def self.down
    remove_column :constituencies,:distance
  end
end
