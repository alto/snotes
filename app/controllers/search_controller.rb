class SearchController < ApplicationController
  
  def index
    Snotes::Twitter.search(params[:query])
    @tweets = Tweet.all(:order => 'created_at DESC', :limit => 20)
  end
  
end