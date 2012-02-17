class CreateEbooks < ActiveRecord::Migration
  def change
    create_table :ebooks do |t|
      t.string :root
      t.integer :book_id

      t.timestamps
    end
  end
end
