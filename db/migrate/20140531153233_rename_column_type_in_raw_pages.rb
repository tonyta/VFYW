class RenameColumnTypeInRawPages < ActiveRecord::Migration
  def change
    rename_column :raw_pages, :type, :category
  end
end
