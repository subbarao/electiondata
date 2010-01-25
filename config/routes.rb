ActionController::Routing::Routes.draw do |map|

  map.root :controller => :seats,:action => :index

  map.resources :seats,:collection => { :nearest => :get },:only => [ :show, :index ]

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
