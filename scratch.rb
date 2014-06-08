RawPage.all.reject{|r| r.html.match(/view from your window contest/i)}.map{|e| Nokogiri::HTML.parse(e.html).css('div.entry-content').css('p')[1].text.strip }


d.map.with_index{|str,i| i.to_s + ": " + str.sub(/\W[ \s]+\d.*/,'')}


RawPage.all.select{|r| r.html.match(/view from your window contest/i)}.map{|e| "#{e.id} #{Nokogiri::HTML.parse(e.html).title}" }


1485
1731


RawPage.views.map{ |e| Nokogiri::HTML.parse(e.html).css('div.entry-content').css('p')[1].text.strip }



RawPage.views.each do |v|
  raw_html = v.html
  url = v.url
  noko = Nokogiri::HTML.parse(raw_html)
  posted_at = Time.parse(noko.css('span.the-time').text)
  description = noko.css('div.entry-content').css('p')[1].text.strip
  location = description.sub(/\W[ \s]+\d.*/,'')
  time_str = if time_match = description.match(/\d+\.?\d*.?((am)|(pm))/)
               time_match[0]
             else
               false
             end
  taken_at = time_str ? Time.new(time_str, posted_at) : nil

  content = noko.css('div.entry-content')[0]
  picture_url = content.css('a')[0].attributes['href'].value
  unless picture_url.match('sullydish.files.wordpress.com')
    if lazy = content.css('img')[0].attributes['data-lazy-src']
      picture_url = lazy.value
    else
      picture_url = nil
    end
  end

  View.create(url: url,
              posted_at: posted_at,
              description: description,
              location: location,
              time_taken: taken_at,
              picture_url: picture_url)
end


desc.map { |d| time = d.match(/\d+\.?\d*.?((am)|(pm))/); time ? "#{time[0]}       #{d}" : d }



RawPage.views.map do |e|
  content = Nokogiri::HTML.parse(e.html).css('div.entry-content')[0]
  if lazy = content.css('img')[0].attributes['data-lazy-src']
    url = lazy.value
  else
    url = content.css('a')[0].attributes['href'].value
  end
  "#{e.id} #{url}"
end

RawPage.views.map do |e|
  content = Nokogiri::HTML.parse(e.html).css('div.entry-content')[0]
  url = content.css('a')[0].attributes['href'].value
  unless url.match('sullydish.files.wordpress.com')
    if lazy = content.css('img')[0].attributes['data-lazy-src']
      url = lazy.value
    else
      url = "<---------ERROR--------->"
    end
  end
  "#{e.id} #{url}"
end

1404
1753


RawPage.views[0..1].map do |v|
  raw_html = v.html
  noko = Nokogiri::HTML.parse(raw_html)
  posted_at = Time.parse(noko.css('span.the-time').text)
  description = noko.css('div.entry-content').css('p')[1].text.strip
  time_str = if time_match = description.match(/\d+\.?\d*.?((am)|(pm))/)
               time_match[0]
             else
               false
             end
  taken_at = time_str ? Time.new(time_str, posted_at) : nil
end


  content = noko.css('div.entry-content')[0]
  picture_url = content.css('a')[0].attributes['href'].value
  unless picture_url.match('sullydish.files.wordpress.com')
    if lazy = content.css('img')[0].attributes['data-lazy-src']
      picture_url = lazy.value
    else
      picture_url = nil
    end
  end

  View.create(url: url,
              posted_at: posted_at,
              description: description,
              location: location,
              time_taken: taken_at,
              picture_url: picture_url)
end


["177 St. Quentin du Dropt, France 9.20 am 2013-11-10 17:20:00 UTC",
 "402 Labuan bajo, Indonesia 6.20 pm 2013-02-28 02:20:00 UTC",
 "427 Long Beach, California 8.30 am 2013-01-31 16:30:00 UTC",
 "442 New York City, New York 9.30 am 2013-01-13 17:30:00 UTC",
 "457 Gruver, Texas 9am 2012-12-28 17:00:00 UTC",
 "608 Firenze, Italy, at 5.02 pm 2012-07-20 00:02:00 UTC",
 "634 San Francisco, California 10.45 am 2012-06-22 17:45:00 UTC",
 "845 Buenos Aires, Argentina 5.30 pm 2013-03-09 01:30:00 UTC"]

url = URI.parse("http://api.tiles.mapbox.com/v3/tonyta.idmp7oda/geocode/Udaipur+India;Khuntan+Thailand.json")



"id in ('2459')"
2459 - special (at my window!)

"id in ('2638','2639','2641')"
2638 - contest
2639 - contest
2641 - contest

"id in ('1731','1485','2406','2801','2812','2828','2835','2843','2853','3034')"
1731 - XXX racoons, omit
1485 - bird... omit
2406 - contest archive... omit
2801 - about book... omit
2812 - about book... omit
2828 - about book... omit
2835 - about book... omit
2843 - about book... omit
2853 - about book... omit
3034 - about book... omit

"id in ('2155','2458','2160','2316','2335','3096','3467','3613')"
2155 - tehran pic from 2009 (not 2011)
2458 - double-rainbow (3 pics)
2160 - comment belongs to id 2161
2316 - comment belongs to id 2318
2335 - comment belongs to id 2336
3096 - triple views!
3467 - triple views!
3613 - old archive from the atlantic

http://dish.andrewsullivan.com/2010/10/11/the-view-from-your-window-14-27/ -- omit


location fix

> <
> <

https://geoservices.tamu.edu/Services/Geocode/WebService/GeocoderWebServiceHttpNonParsed_V04_01.aspx?&city=San%20Andres%20Island&state=ca&zip=90210&apikey=cad0ff6dfd434a0788e344e89109d61e&format=csv&census=true&censusYear=2000|2010&notStore=false&version=4.01


v.geocode_json.each do |geo|
  puts geo["type"]
  if geo["type"].match(/town|city/)
    hash = {display_name: geo["display_name"], lat: geo["lat"], lon: geo["lon"]}
    v.update(hash)
    break
  end
end


10.7754799,106.7021449
noon|afternoon|morning|today|midnight|dusk|sunset|dawn

view = View.first

pic_url = view.picture_url
uri = URI.parse(pic_url)
uri.query = URI.encode_www_form(w: 400)

ext = uri.path.match(/\.(\w{3,4})$/)[1]
tmp_file = Rails.root.join('tmp', 'img', "tmp_image.#{ext}")

Net::HTTP.start(uri.host) do |http|
  response = http.get(uri)
  open(tmp_file, 'wb') { |f| f.write response.body }
end

view.image = File.open(tmp_file)
view.save!

pg