class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.string :url
      t.datetime :posted_at
      t.string :description
      t.string :location

      t.timestamps
    end
  end
end
