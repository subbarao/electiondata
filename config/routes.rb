ActionController::Routing::Routes.draw do |map|
  map.resources :nominations

  map.root :controller => "constituencies",:action => "donothing"
  map.resources :constituencies,:collection => { :donothing=>:get, :current => :get ,:all => :get, :find => :get},:member =>{:test=>:get}
  map.resources :results
  map.resources :nominations
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
