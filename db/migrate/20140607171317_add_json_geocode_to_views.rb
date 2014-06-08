class AddJsonGeocodeToViews < ActiveRecord::Migration
  def change
    add_column :views, :geocode_json, :json
  end
end
