ActionController::Routing::Routes.draw do |map|
  map.resources :courses do |courses|
    courses.resources :lectures, {:controller => :lectures}
  end
  map.resources :lectures, :controller => :lectures, :except => [:create] do |lectures|
    lectures.resources :file_assets, :only => [:index, :new]
  end
end

