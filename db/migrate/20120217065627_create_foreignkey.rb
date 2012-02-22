class CreateForeignkey < ActiveRecord::Migration
  def up
    change_table :pagebooks do |book|
      book.references :book
    end
  end

  def down

  end
end
