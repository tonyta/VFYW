class View < ActiveRecord::Base

  mount_uploader :image, ImageUploader

  validate :url, uniqueness: true

  def taken_at
    Time.at(seconds_since_midnight).getgm.strftime('%l:%M %P')
  end

  def to_geojson
    geojson = {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [self.lon,self.lat]
      },
      properties: {
        id: self.id,
        time: time,
        date: date,
        thumb: self.image.thumb.url,
        title: self.location,
        "marker-color" => get_color,
        "marker-size" => "small"
      }
    }
  end

  def self.geojson
    views = View.all.reject do |v|
      v.seconds_since_midnight.nil? ||
      v.lat.nil? ||
      v.image.url.nil?
    end
    views.map(&:to_geojson).to_json
  end



    def date
      self.posted_at.to_i * 1000
    end

    def time
      return nil if seconds_since_midnight.nil?
      self.seconds_since_midnight / 3600
    end

    def get_color
      return nil if time.nil?
      time = self.time
      if time < 4
        '#050926'
      elsif time == 4
        '#021B53'
      elsif time == 5
        '#126482'
      elsif time == 6
        '#C4A65A'
      elsif time == 7
        '#C0E0DD'
      elsif time < 18
        '#BAD6FF'
      elsif time == 18
        '#93C0FF'
      elsif time == 19
        '#745FD3'
      elsif time == 20
        '#B64DC1'
      elsif time == 21
        '#773A7F'
      else
        '#050926'
      end
    end

end


 # {
 #    "type": "Feature",
 #    "geometry": {
 #      "type": "Point",
 #      "coordinates": [-77.03238901390978,38.913188059745586]
 #    },
 #    "properties": {
 #      "title": "Mapbox DC",
 #      "description": "1714 14th St NW, Washington DC",
 #      "marker-color": "#fc4353",
 #      "marker-size": "large",
 #      "marker-symbol": "monument"
 #    }
 #  }