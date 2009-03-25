class AddLatLngToConstituency < ActiveRecord::Migration
  def self.up
    add_column :constituencies,:lat,:float
    add_column :constituencies,:lng,:float
  end
  def self.down
    remove_column :constituencies,:lat
    remove_column :constituencies,:lng
  end
end
