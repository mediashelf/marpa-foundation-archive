# encoding: utf-8
require "spec_helper"

describe RecordingInstantiationsController do
  it "should route" do
    {:get=>'/talks/marpa:6/recording_instantiations'}.should route_to(:controller=>'recording_instantiations', :action=>'index', :talk_id=>'marpa:6')
  end

  describe "create" do
    before do
      @talk = Talk.create
      @recording = Recording.create(:talk=>@talk)
      sign_in FactoryGirl.find_or_create(:archivist)
    end
    after do
      @talk.delete
      @recording.delete
    end
    it "should store uploaded filedata in S3" do
      @recording_instantiation = RecordingInstantiation.new
      RecordingInstantiation.expects(:new).returns(@recording_instantiation)
      file = fixture_file_upload('spec/fixtures/YogurtMeow.mp3','application/mp3')
      xhr :post, :create, :files=>[file], :Filename=>"Meow.mp3", :talk_id =>@talk.pid

      response.should be_success
      object = JSON.parse(response.body)[0]
      object["name"].should == @recording_instantiation.pid
      object["url"].should == "/recording_instantiations/#{@recording_instantiation.pid}"
      assigns[:instantiation].should == @recording_instantiation
      assigns[:instantiation].recording.should == @recording
      assigns[:instantiation].talk.should == @talk
    end
  end

  describe "index" do
    before do
      @talk = Talk.create
      @recording = Recording.create(:talk=>@talk)
      @recording_instantiation = RecordingInstantiation.create(:recording=>@recording)
    end
    it "should return a json array" do
      ## TODO route should be talk/talk_id/recording_instantiations
      xhr :get, :index, :talk_id=>@talk.pid
      object = JSON.parse(response.body)
      object.should be_kind_of Array
      object[0]['name'].should == @recording_instantiation.pid
    end
  end

  
end
