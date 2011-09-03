require 'spec_helper'

describe TalksController do
    it "should route to '/talks/new'" do
      { :get => new_talk_path() }.should route_to(:controller => 'talks', :action => 'new')
    end
    it "should route to '/talks/:id/add_song'" do
      { :post => add_song_talk_path(7) }.should route_to(:controller => 'talks', :action => 'add_song', :id=>"7")
    end
    it "should route to '/talks/:id/add_quotation'" do
      { :post => add_quotation_talk_path(7) }.should route_to(:controller => 'talks', :action => 'add_quotation', :id=>"7")
    end
    it "should route to add_text_talk" do
      { :post => add_talk_text_talk_path('fixture:1') }.should route_to(:controller => 'talks', :action => 'add_talk_text', :id=>'fixture:1')
    end

end
