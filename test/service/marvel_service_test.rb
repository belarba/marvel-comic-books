require 'minitest/autorun'
require 'webmock/minitest'

class MarvelServiceTest < Minitest::Test
  def setup
    @marvel_service = MarvelService.new
  end

  def test_comics_returns_parsed_response
    stub_request(:get, "https://gateway.marvel.com/v1/public/comics").
      with(query: hash_including(apikey: ENV['MARVEL_PUBLIC_KEY'])).
      to_return(status: 200, body: { data: { results: [{ id: 1, title: 'Comic 1' }] } }.to_json, headers: { 'Content-Type' => 'application/json' })

    response = @marvel_service.comics
    assert_equal 1, response['data']['results'].size
    assert_equal 'Comic 1', response['data']['results'].first['title']
  end

  def test_character_id_returns_character_id
    character_name = "Spider-Man"
    stub_request(:get, "https://gateway.marvel.com/v1/public/characters").
      with(query: hash_including(apikey: ENV['MARVEL_PUBLIC_KEY'], name: character_name)).
      to_return(status: 200, body: { data: { results: [{ id: 1011334, name: 'Spider-Man' }] } }.to_json, headers: { 'Content-Type' => 'application/json' })

    character_id = @marvel_service.character_id(character_name)
    assert_equal 1011334, character_id
  end

  def test_character_id_returns_nil_when_no_results
    character_name = "Unknown Character"
    stub_request(:get, "https://gateway.marvel.com/v1/public/characters").
      with(query: hash_including(apikey: ENV['MARVEL_PUBLIC_KEY'], name: character_name)).
      to_return(status: 200, body: { data: { results: [] } }.to_json, headers: { 'Content-Type' => 'application/json' })

    character_id = @marvel_service.character_id(character_name)
    assert_nil character_id
  end

  def test_character_comics_returns_parsed_response
    character_id = 1011334
    stub_request(:get, "https://gateway.marvel.com/v1/public/characters/#{character_id}/comics").
      with(query: hash_including(apikey: ENV['MARVEL_PUBLIC_KEY'])).
      to_return(status: 200, body: { data: { results: [{ id: 1, title: 'Spider-Man Comic' }] } }.to_json, headers: { 'Content-Type' => 'application/json' })

    response = @marvel_service.character_comics(character_id)
    assert_equal 1, response['data']['results'].size
    assert_equal 'Spider-Man Comic', response['data']['results'].first['title']
  end
end
