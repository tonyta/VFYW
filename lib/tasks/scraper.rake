require Rails.root.join('db', 'scraper.rb')

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

  desc "categorizes raw_pages to 'view', 'contest', 'winner', and 'other'"
  task :categorize => :environment do
    RawPage.all.reject { |r| r.html.match(/view from your window contest/i) }
           .each { |r| r.update(category: 'view') }

    RawPage.all.select { |r| r.html.match(/(xxx edition)|(outtake)/i) }
           .each { |r| r.update(category: 'other') }

    RawPage.all.select { |r| r.html.match(/view from your window contest/i) }
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
      location = nil if location.length > 255
      time_str = if time_match = description.match(/\d+\.?\d*.?((am)|(pm))/)
                   time_match[0].sub('.', ':')
                 else
                   false
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

      view = View.create(url: url,
                         posted_at: posted_at,
                         description: description,
                         location: location,
                         seconds_since_midnight: seconds_since_midnight,
                         picture_url: picture_url)
      puts view.id
    end
  end
end