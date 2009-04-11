class AddCategoryToSeat < ActiveRecord::Migration
  def self.up
    add_column :seats,:category,:string
    add_column :seats,:year,:integer
  end

  def self.down
    remove_column :seats,:category
    remove_column :seats,:year
  end
end
