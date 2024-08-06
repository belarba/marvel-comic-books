require 'test_helper'
require 'webmock/minitest'

class ComicsControllerTest < ActionDispatch::IntegrationTest
  def setup
    thumbnail_path = ActionController::Base.helpers.asset_path('page.png')
    @comics_response = {
      'data' => {
        'results' => [{
          id: 1,
          title: 'Comic 1',
          thumbnail: { 'path' => thumbnail_path, 'extension' => 'png' }
        }]
      }
    }
    @character_comics_response = {
      'data' => {
        'results' => [{
          id: 2,
          title: 'Spider-Man Comic',
          thumbnail: { 'path' => thumbnail_path, 'extension' => 'png' }
        }]
      }
    }
  end

  def test_index_without_character
    # Mockando a resposta da API de comics
    stub_request(:get, "https://gateway.marvel.com/v1/public/comics").
      with(query: hash_including(apikey: ENV['MARVEL_PUBLIC_KEY'])).
      to_return(status: 200, body: @comics_response.to_json, headers: { 'Content-Type' => 'application/json' })

    get comics_path
    assert_response :success

    # Verifica se a variável @comics foi atribuída corretamente
    assert_not_nil assigns(:comics)
    assert_equal 1, assigns(:comics)['data']['results'].size
    assert_equal 'Comic 1', assigns(:comics)['data']['results'].first['title']
  end

  def test_index_with_character
    # Mockando a resposta da API de characters
    stub_request(:get, "https://gateway.marvel.com/v1/public/characters").
      with(query: hash_including(apikey: ENV['MARVEL_PUBLIC_KEY'], name: "Spider-Man")).
      to_return(status: 200, body: { data: { results: [{ id: 1011334, name: 'Spider-Man' }] } }.to_json, headers: { 'Content-Type' => 'application/json' })

    # Mockando a resposta da API de comics do personagem
    stub_request(:get, "https://gateway.marvel.com/v1/public/characters/1011334/comics").
      with(query: hash_including(apikey: ENV['MARVEL_PUBLIC_KEY'])).
      to_return(status: 200, body: @character_comics_response.to_json, headers: { 'Content-Type' => 'application/json' })

    get comics_path, params: { character: "Spider-Man" }
    assert_response :success
    assert_not_nil assigns(:comics)
    assert_equal 1, assigns(:comics)['data']['results'].size
    assert_equal 'Spider-Man Comic', assigns(:comics)['data']['results'].first['title']
  end

  def test_favorite_adds_comic_to_session
    comic_id = 1
    post favorite_comic_path(id: comic_id)

    assert_redirected_to comics_path
    assert_includes session[:favorites], comic_id
  end

  def test_favorite_removes_comic_from_session
    comic_id = 1
    # add
    post favorite_comic_path(id: comic_id)
    # remove
    post favorite_comic_path(id: comic_id)

    assert_redirected_to comics_path
    refute_includes session[:favorites], comic_id
  end

  def test_favorite_icon_toggle
    comic_id = 1
    post favorite_comic_path(id: comic_id), as: :json
    assert_response :success
    assert_equal 'heart_on.png', JSON.parse(response.body)['icon']

    post favorite_comic_path(id: comic_id), as: :json
    assert_response :success
    assert_equal 'heart_off.png', JSON.parse(response.body)['icon']
  end
end
