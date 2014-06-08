class Nominatim
  attr_reader :uri
  API_URI = "http://nominatim.openstreetmap.org/search"

  def initialize
    @uri = URI.parse(API_URI)
  end

  def query(query_str='')
    query = {format: 'json', q: query_str}
    self.uri.query = URI.encode_www_form(query)
    JSON.parse(http_get)
  end

  def query_to_hash(query_str)
    JSON.parse( query(query_str) )
  end

  private

    def http_get
      Net::HTTP.get(uri)
    end
end