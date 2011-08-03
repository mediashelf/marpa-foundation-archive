require 'spec_helper'

describe TalksController do
    it "should route to '/talks/new'" do
      { :get => new_talk_path() }.should route_to(:controller => 'talks', :action => 'new')
    end

end
