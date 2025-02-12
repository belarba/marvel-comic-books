class ComicsController < ApplicationController
  def index
    @character = params[:character] if params[:character].present?
    @page = params[:page].to_i || 0
    @comics = if params[:character]
                character_id = MarvelService.new.character_id(params[:character])
                character_id ? MarvelService.new.character_comics(character_id, @page) : { 'data' => { 'results' => [] } }
              else
                MarvelService.new.comics(@page)
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
