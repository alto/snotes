class SearchController < ApplicationController
  
  def index
    # @results = Twitter::Search.new(params[:query])
    @results = Snotes::Twitter.search(params[:query])
  end
  
end
