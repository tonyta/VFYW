class ResetViews < ActiveRecord::Migration
  def up
    drop_table :views

    create_table :views do |t|
      t.string :url
      t.text :description
      t.string :location
      t.string :picture_url

      t.datetime :posted_at
      t.integer :seconds_since_midnight

      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lon, precision: 9, scale: 6

      t.timestamps
    end
  end

  def down
    drop_table :views
    create_table :views
  end
end
