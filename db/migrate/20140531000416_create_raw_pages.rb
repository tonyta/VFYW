class CreateRawPages < ActiveRecord::Migration
  def change
    create_table :raw_pages do |t|
      t.string :url
      t.text :html
      t.boolean :is_contest, default: false
      t.timestamps
    end
  end
end
