class MarvelService
  include HTTParty
  base_uri 'https://gateway.marvel.com/v1/public'

  def initialize
    @timestamp = Time.now.to_i.to_s
    @public_key = ENV['MARVEL_PUBLIC_KEY']
    @private_key = ENV['MARVEL_PRIVATE_KEY']
    @hash = generate_hash
    @base_query = {
      apikey: @public_key,
      ts: @timestamp,
      hash: @hash,
      limit: 5
    }
  end

  def comics(offset = 0)
    cache_key = "marvel_comics_#{offset}"
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      options = { query: @base_query.merge(offset: offset) }
      response = self.class.get('/comics', options)
      Rails.logger.debug "Marvel API response: #{response.body}"
      response.parsed_response
    end
  end

  def character_id(name)
    cache_key = "marvel_character_id_#{name}"
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      options = { query: @base_query.merge(name: name) }
      response = self.class.get('/characters', options)
      Rails.logger.debug "Marvel API response character id: #{response.body}"
      parsed_response = response.parsed_response
      if parsed_response['data'] && parsed_response['data']['results'] && !parsed_response['data']['results'].empty?
        id = parsed_response['data']['results'].first['id']
        Rails.logger.debug "Marvel API response character id: #{id}"
        id
      else
        nil
      end
    end
  end

  def character_comics(id, offset = 0)
    p "entrou no character comicsdddddd"
    p id
    cache_key = "marvel_character_comics_#{id}_#{offset}"
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      options = { query: @base_query.merge(offset: offset) }
      response = self.class.get("/characters/#{id}/comics", options)
      Rails.logger.debug "Character Comics response: #{response.body}"
      response.parsed_response
    end
  end

  private

  def generate_hash
    Digest::MD5.hexdigest("#{@timestamp}#{@private_key}#{@public_key}")
  end
end
