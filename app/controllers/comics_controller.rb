class ComicsController < ApplicationController
  def index
    @comics = MarvelService.new.comics
    Rails.logger.debug "Comics response: #{@comics.inspect}"
  end
end
