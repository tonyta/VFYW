require Rails.root.join('db', 'nominatim.rb')

namespace :geo do

  desc "geocodes all views"
  task :geocode => :environment do
    geocoder = Nominatim.new

    View.find_each do |v|
      next unless v.geocode_json.nil?
      location = v.location
      print "#{location} --> "

      response = geocoder.query(location)

      if response.empty?
        puts "NONE FOUND"
      else
        puts response[0]['display_name']
        v.update(geocode_json: response)
      end
    end
  end

  desc "selects best matched element from geocode_json"
  task :select_geo => :environment do
    View.find_each do |v|
      next if v.geocode_json.nil?
      puts "#{v.location} (#{v.id})"

      selected = false

      match_type1 = /town|city|village|administrative/
      match_type2 = /neighborhood|suburb|hamlet|locality/
      match_class = /natural/

      v.geocode_json.each do |geo|
        if geo["class"].match(match_class) || geo["type"].match(match_type1)
          puts "  #{geo["type"]} --> #{geo["display_name"]}"
          info = {display_name: geo["display_name"],
                  lat: geo["lat"],
                  lon: geo["lon"]}
          v.update(info)
          selected = true
          break
        end
        puts "    skipping #{geo["type"] ? geo["type"] : geo["class"]}"
      end

      unless selected
        puts "  -- second pass --"
        v.geocode_json.each do |geo|
          if geo["type"].match(match_type2)
            puts "  #{geo["type"]} --> #{geo["display_name"]}"
            info = {display_name: geo["display_name"],
                    lat: geo["lat"],
                    lon: geo["lon"]}
            v.update(info)
            selected = true
            break
          end
          puts "    skipping #{geo["type"] ? geo["type"] : geo["class"]}"
        end
      end

    end
  end

  task :select_geo_manual => :environment do
    puts "\# - select location\ne - manually set display_name, lat, and lon\ns - skip\n"
    View.where(display_name: nil).each do |view|
      next if view.display_name

      location = view.location
      www_encode = URI.encode_www_form(q: location)
      Launchy.open(view.url)
      Launchy.open("http://google.com/search?#{www_encode}")
      puts "#{location} [#{view.id}]"

      if view.geocode_json
        view.geocode_json.each_with_index do |geo, i|
          puts "  [#{i}]  #{geo['display_name']}  --  #{geo['class']}, #{geo['type']}"
        end
      else
        puts "  NOT GEOCODED"
      end

      input = nil
      while input.nil?
        print "  > "
        input = STDIN.gets.chomp
        case
        when input == 's'
          next
          puts "  Skipping.\n"
        when input == 'e'
          print "  > display_name: "
          display_name = STDIN.gets.chomp
          display_name = display_name.empty? ? view.location : display_name
          print "  > lat/lon: "
          lat_lon = STDIN.gets.chomp
          lat, lon = lat_lon.split(',').map(&:to_f)
          view.update(display_name: display_name, lat: lat, lon: lon)
          puts "  Updated to: #{view.reload.display_name}\n"
        when input.match(/\d/)
          index = input.to_i
          geo = view.geocode_json[index]
          info = {display_name: geo["display_name"],
                  lat: geo["lat"],
                  lon: geo["lon"]}
          view.update(info)
          puts "  Updated to: #{view.reload.display_name}\n"
        else
          input = nil
          puts "  Invalid input ('e' - edit, 's' - skip, \# - select)"
        end
      end

    end
  end

  task :display_unsorted => :environment do
    View.where(display_name: nil).each do |view|
      puts view.location
      if view.geocode_json
        view.geocode_json.each do |geo|
          puts "  #{geo['display_name']}  --  #{geo['class']}, #{geo['type']}"
        end
      else
        puts "  NOT GEOCODED"
      end
    end
  end

  desc "bakes out geojson file"
  task :bake => :environment do
    file_path = Rails.root.join('public', 'assets', 'js', 'geojson.js')
    f = File.open(file_path, 'w+') do |f|
      f.write "var geojson = "
      f.write View.geojson
    end
  end

end