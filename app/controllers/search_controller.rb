class SearchController < ApplicationController
  expose(:need)

  def find_need
    authorize! :read, Need

    @bookmarks = current_user.bookmarks

    if request.query_parameters.has_key?("q")
      @needs = Search.search params[:q]
    end
  end
end
