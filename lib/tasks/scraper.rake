#encoding: utf-8

require Rails.root.join('db', 'nominatim.rb')

namespace :scraper do
  desc "scrapes urls for vfyw pages"
  task :get_urls => :environment do
    puts "scraping urls..."
    scraper = Scraper.new
    scraper.scrape!
  end

  desc "downloads raw html"
  task :get_html => :environment do
    require Rails.root.join('db', 'seed_2012_to_05_2014.rb')
  end

  desc "downloads raw html"
  task :get_html2 => :environment do
    require Rails.root.join('db', 'seed_2006_to_2011.rb')
  end

  desc "categorizes raw_pages to 'view', 'contest', 'winner', and 'other'"
  task :categorize => :environment do
    unparsed = RawPage.all.reject { |r| r.is_parsed }

    unparsed.reject { |r| r.html.match(/view from your window contest/i) }
      .each { |r| r.update(category: 'view', is_parsed: true) }

    unparsed.select { |r| r.html.match(/(xxx edition)|(outtake)/i) }
      .each { |r| r.update(category: 'other') }

    RawPage.where("id in ('2459')")
           .each { |r| r.update(category: 'contest', is_parsed: true) }

    RawPage.where("id in ('2638','2639','2641','4160')")
           .each { |r| r.update(category: 'special', is_parsed: true) }

    RawPage.where("id in ('1731','1485','2406','2801','2812','2828','2835','2843','2853','3034','2081')")
           .each { |r| r.update(category: 'omit', is_parsed: true) }

    RawPage.where("id in ('2155','2458','2160','2316','2335','3096','3467','3613')")
           .each { |r| r.update(category: 'manual', is_parsed: true) }

    unparsed.select { |r| r.html.match(/view from your window contest/i) }
      .each do |r|
        title = Nokogiri::HTML.parse(r.html).title
        if title.match(/winner/i)
          r.update(category: 'winner')
        else
          r.update(category: 'contest')
        end
      end
  end

  desc "migrates data from raw_pages to views"
  task :convert_raw => :environment do
    RawPage.views.each do |v|
      raw_html = v.html
      p url = v.url
      noko = Nokogiri::HTML.parse(raw_html)
      posted_at = Time.parse(noko.css('span.the-time').text)
      description = noko.css('div.entry-content').css('p')[1].text.strip
      location = description.sub(/\W[ \s]+\d.*/,'')
      if location.length > 255
        Launchy.open(url)
        print 'location: '
        input = STDIN.gets.chomp
        input = nil if input == ""
        location = input
      end
      time_str = if time_match = description.match(/\d+\.?\d*.?((am)|(pm))/)
                   time_match[0].sub('.', ':')
                 else
                   Launchy.open(url)
                   print "time string: "
                   input = STDIN.gets.chomp
                   input == "" ? false : input
                 end
      seconds_since_midnight = time_str ? Time.parse(time_str, posted_at).seconds_since_midnight : nil

      content = noko.css('div.entry-content')[0]
      picture_url = content.css('a')[0].attributes['href'].value
      unless picture_url.match('sullydish.files.wordpress.com')
        if lazy = content.css('img')[0].attributes['data-lazy-src']
          picture_url = lazy.value
        else
          picture_url = nil
        end
      end

      view = View.create!(url: url,
                          posted_at: posted_at,
                          description: description,
                          location: location,
                          seconds_since_midnight: seconds_since_midnight,
                          picture_url: picture_url)
      puts view.id
    end
  end

  task :clean_loc => :environment do
    View.all.each do |view|
      location = view.location
      if location.match(/\d/) || location.length > 30 || !location.match(/,/) || location.empty?
        Launchy.open(view.url)
        puts "current location: #{location}"
        print "fix location: "
        input = STDIN.gets.chomp
        unless input.empty?
          view.update(location: input)
        end
      end
    end
  end

  task :clean_loc2 => :environment do
    View.all.each do |view|
      location = view.location
      match = /noon|afternoon|morning|today|midnight|dusk|sunset|dawn|State/
      if location.match(match) || location.match(/\.$/)
        puts "current location: #{location}"
        print "fix location: "
        input = STDIN.gets.chomp
        unless input.empty?
          view.update(location: input, geocode_json: nil)
        end
      end
    end
  end

  task :clean_loc3 => :environment do
    View.all.each do |view|
      if view.geocode_json.nil?
        location = view.location
        www_encode = URI.encode_www_form(q: location)
        puts "current location: #{location}"
        Launchy.open(view.url)
        Launchy.open("http://google.com/search?#{www_encode}")
        print "fix location: "
        input = STDIN.gets.chomp
        unless input.empty?
          view.update(location: input, geocode_json: nil)
        end
      end
    end
  end

  task :clean_pic => :environment do
    View.all.each do |view|
      if view.picture_url.nil?
        Launchy.open(view.url)
        print "picture url: "
        input = STDIN.gets.chomp
        unless input.empty?
          view.update(picture_url: input)
        end
      end
    end
  end
end
