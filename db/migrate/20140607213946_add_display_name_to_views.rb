class AddDisplayNameToViews < ActiveRecord::Migration
  def change
    add_column :views, :display_name, :string
  end
end
