ActionController::Routing::Routes.draw do |map|
  
  map.search 'search', :controller => 'search', :action => 'search'
  map.track  'track',  :controller => 'search', :action => 'track'
  
end
