class SearchController < ApplicationController
  
  def tweets
    Snotes::Twitter.search
    @tweets = Tweet.all(:order => 'created_at DESC', :limit => 20)
    render :action => 'search'
  end
  
end
