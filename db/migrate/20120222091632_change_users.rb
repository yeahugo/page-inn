class ChangeUsers < ActiveRecord::Migration
  def up
    add_column :users, :matrixcode, :string
    add_column :users, :udid, :string
  end
  def down
    remove_column :users, :matrixcode, :string
    remove_column :users, :udid, :string
  end
end
