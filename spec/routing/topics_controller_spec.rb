require 'spec_helper'

describe TopicsController do
    it "should route to '/topics/new'" do
      { :get => new_topic_path() }.should route_to(:controller => 'topics', :action => 'new')
    end

end
