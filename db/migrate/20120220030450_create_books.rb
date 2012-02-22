class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn
      t.string :root
      t.integer :status

      t.timestamps
    end
  end
end
