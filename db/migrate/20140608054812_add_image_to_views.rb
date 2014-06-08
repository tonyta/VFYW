class AddImageToViews < ActiveRecord::Migration
  def change
    add_column :views, :image, :string
  end
end
