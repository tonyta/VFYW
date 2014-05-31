require 'yaml'

file = Rails.root.join('db', 'urls_2012_to_05_2014.yaml')

hash = YAML.load(open file)

url_arr = hash.values
              .map(&:values).flatten
              .map(&:values).flatten
              .select { |str| str.match('dish') }


url_arr.each_with_index do |url, i|
  puts "#{i+1}: #{url}"
  html = Net::HTTP.get(URI.parse(url))
  RawPage.create(url: url, html: html)
end

# creates 1127 records