class CreateBookUserships < ActiveRecord::Migration
  def change
    create_table :book_userships do |t|
      t.integer :user_id
      t.integer :book_id
      t.integer :type

      t.timestamps
    end
  end
end
