class AddDetailsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :tags, :string

    add_column :books, :summary, :text

  end
end
