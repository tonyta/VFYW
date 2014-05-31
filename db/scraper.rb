require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'yaml'

TARGET_URI = 'http://dish.andrewsullivan.com'
URI_OUTPUT = Rails.root.join('db', 'vfyw_urls.yaml')

class YAMLParser
  attr_accessor :file_path, :contents

  def initialize
    @file_path = URI_OUTPUT
    @contents = YAML.load(open(file_path)) || {}
  end

  def add_item(*args)
    data = args.pop
    data_struct = contents
    args.each do |key|
      data_struct[key] = {} if data_struct[key].nil?
      data_struct = data_struct[key]
    end
    data_struct[:data] = [] if data_struct[:data].nil?
    if data.is_a?(Array)
      data_struct[:data].push(*data)
    else
      data_struct[:data] << data
    end
  end

  def save!
    File.open(file_path, 'w+') do |file|
      file.write contents.to_yaml
    end
  end
end

class Scraper
  attr_accessor :uri, :year, :month, :page_num, :yaml, :page

  def initialize
    @yaml = YAMLParser.new
    @uri = URI.parse TARGET_URI

    @year = 2011 # Time.now.year
    @month = 12 # Time.now.month
    @page_num = 1

    @page = nil
  end

  def scrape!
    until year == 2000
      get_page
      extract_urls
    end
    yaml.save!
  end

  def get_page
    unless self.page = fetch_page
      yaml.save!
      next_month
      self.page = fetch_page
    end
    next_page
    p uri.to_s
  end

  def fetch_page
    update_uri
    begin
      Nokogiri::HTML(open uri)
    rescue
      false
    end
  end

  def next_page
    self.page_num += 1
  end

  def next_month
    if month == 1
      self.month = 12
      self.year -= 1
    else
      self.month -= 1
    end
    self.page_num = 1
  end

  def extract_urls
    views = page.css('a').select do |anchor|
      anchor.text =~ /the view from your window/i
    end
    urls = views.map { |view| view['href'] }
                .select { |href| href.match('dish') }
    yaml.add_item(year, month, urls) unless urls.empty?
  end

  def page_path
    return '' if page_num == 1
    "page/#{page_num}/"
  end

  def pathify
    "/%s/%s/%s" % [year, month, page_path]
  end

  def update_uri
    uri.path = pathify
  end
end
