class CreateForeginkeyEbook < ActiveRecord::Migration
  def up
    change_table :ebooks do |book|
      book.references :book
    end
  end

  def down
  end
end
