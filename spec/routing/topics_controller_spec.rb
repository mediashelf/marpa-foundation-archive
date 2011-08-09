require 'spec_helper'

describe TopicsController do
    it "should route to '/topics/create'" do
      { :post => topics_path() }.should route_to(:controller => 'topics', :action => 'create')
    end

end
