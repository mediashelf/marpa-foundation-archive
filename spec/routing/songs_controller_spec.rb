require 'spec_helper'

describe SongsController do
    it "should route to '/songs/create'" do
      { :post => songs_path() }.should route_to(:controller => 'songs', :action => 'create')
    end

end
