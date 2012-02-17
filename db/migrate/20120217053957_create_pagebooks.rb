class CreatePagebooks < ActiveRecord::Migration
  def change
    create_table :pagebooks do |t|
      t.string :code
      t.integer :status
      t.integer :Book_id
      t.integer :List_id

      t.timestamps
    end
  end
end
