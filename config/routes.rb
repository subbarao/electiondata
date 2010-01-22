ActionController::Routing::Routes.draw do |map|
  map.resources :nominations
  map.root :controller => "results",:action => "init"
  map.resources :constituencies,:collection => { :donothing =>:get, :current => :get ,:all => :get, :find => :get},:member =>{:test=>:get},:except => [:update,:edit,:create]
  map.history '/history',:controller => "constituencies",:action => "donothing"
  map.resources :results,:collection => {:init => :get}
  map.resources :nominations
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
