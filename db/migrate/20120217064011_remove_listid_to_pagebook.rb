class RemoveListidToPagebook < ActiveRecord::Migration
  def up
    remove_column :pagebooks, :List_id
  end
  def down
    add_column:pagebooks, :List_id,:integer
  end
end
