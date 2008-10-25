class SearchController < ApplicationController
  
  def search
    Snotes::Twitter.search
    @tweets = Tweet.find(:all, :order => 'created_at DESC', :limit => 20)
    render :action => 'search'
  end
  
end
