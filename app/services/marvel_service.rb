# app/services/marvel_service.rb
class MarvelService
  include HTTParty
  base_uri 'https://gateway.marvel.com/v1/public'

  def initialize
    @options = { query: { apikey: ENV['MARVEL_PUBLIC_KEY'] } }
  end

  def comics(offset = 0)
    self.class.get('/comics', @options.merge(query: { offset: offset }))
  end
end
