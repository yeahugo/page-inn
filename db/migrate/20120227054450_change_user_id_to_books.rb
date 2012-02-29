class ChangeUserIdToBooks < ActiveRecord::Migration
  def up
    rename_column:books,:user_id,:owner
  end

  def down
  end
end
