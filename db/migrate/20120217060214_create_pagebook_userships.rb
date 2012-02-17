class CreatePagebookUserships < ActiveRecord::Migration
  def change
    create_table :pagebook_userships do |t|
      t.integer :pagebook_id
      t.integer :user_id

      t.timestamps
    end
  end
end
