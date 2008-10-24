class SearchController < ApplicationController
  
  def tweets
    Snotes::Twitter.do_your_job
    @tweets = Tweet.all(:order => 'created_at DESC', :limit => 20)
    render :action => 'search'
  end
  
end
