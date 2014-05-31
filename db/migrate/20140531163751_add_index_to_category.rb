class AddIndexToCategory < ActiveRecord::Migration
  def change
    add_index :raw_pages, :category
  end
end
