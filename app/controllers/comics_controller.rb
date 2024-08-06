class ComicsController < ApplicationController
  def index
    @comics = if params[:character]
                character_id = MarvelService.new.character_id(params[:character])
                character_id ? MarvelService.new.character_comics(character_id) : { 'data' => { 'results' => [] } }
              else
                MarvelService.new.comics
              end

    Rails.logger.debug "Comics response: #{@comics.inspect}"
    Rails.logger.info "Current favorites: #{session[:favorites].inspect}"
  end

  def favorite
    comic_id = params[:id]
    session[:favorites] ||= []

    if session[:favorites].include?(comic_id.to_i)
      session[:favorites].delete(comic_id.to_i)
      icon = 'heart_off.png'
    else
      session[:favorites] << comic_id.to_i
      icon = 'heart_on.png'
    end

    respond_to do |format|
      format.html { redirect_to comics_path }
      format.json { render json: { icon: icon } }
    end
  end
end
