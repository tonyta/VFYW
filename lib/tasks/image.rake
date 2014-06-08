namespace :image do
  task :clean_urls => :environment do
    View.find_each do |view|
      page = view.url
      url = view.picture_url
      if url.nil? || !url.match('sullydish.files.wordpress.com')
        Launchy.open(page)
        puts "image_url: #{url || '-- nil --'}"

        print "  picture url > "
        input = STDIN.gets.chomp
        view.update(picture_url: input) unless input.empty?
      else
        next
      end
    end
  end

  task :get_all => :environment do
    View.all.each_with_index do |view, i|
      puts "\##{i} [#{view.id}] #{view.location}"

      pic_url = view.picture_url
      next unless pic_url && pic_url.match('sullydish.files.wordpress.com')
      next if view.image.url

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
    end
  end
end