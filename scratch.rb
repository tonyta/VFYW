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
