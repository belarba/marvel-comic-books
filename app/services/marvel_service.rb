class MarvelService
  include HTTParty
  base_uri 'https://gateway.marvel.com/v1/public'

  def initialize
    @timestamp = Time.now.to_i.to_s
    @public_key = ENV['MARVEL_PUBLIC_KEY']
    @private_key = ENV['MARVEL_PRIVATE_KEY']
    @hash = generate_hash
  end

  def comics(offset = 0)
    options = {
      query: {
        apikey: @public_key,
        ts: @timestamp,
        hash: @hash,
        offset: offset
      }
    }

    response = self.class.get('/comics', options)
    Rails.logger.debug "Marvel API response: #{response.body}"
    response.parsed_response
  end

  private

  def generate_hash
    Digest::MD5.hexdigest("#{@timestamp}#{@private_key}#{@public_key}")
  end
end
