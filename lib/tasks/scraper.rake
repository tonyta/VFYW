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
end