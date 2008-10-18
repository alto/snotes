class SearchController < ApplicationController
  
  def search
    Snotes::Twitter.search(params[:query] || '#snote')
    @tweets = Tweet.all(:order => 'created_at DESC', :limit => 20)
  end
  
  def track
    @tweets = Tracking.conduct
    render :action => 'search'
  end
  
end
