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
end