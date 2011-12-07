ActionController::Routing::Routes.draw do |map|
  map.connect "projects/:project_id/project_stats", :controller => "project_stats" , :action => :index
end