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
end
