class ComicsController < ApplicationController
  def index
    @comics = if params[:character]
                character_id = MarvelService.new.character_id(params[:character])
                character_id ? MarvelService.new.character_comics(character_id) : { 'data' => { 'results' => [] } }
              else
                MarvelService.new.comics
              end

    Rails.logger.debug "Comics response: #{@comics.inspect}"
  end

  def favorite
    p "entrou no favorite"
    comic_id = params[:comic_id]
    Favorite.create(comic_id: comic_id)
    flash[:notice] = "Comic #{comic_id} favorited!"
    redirect_to comics_path
  end
end
