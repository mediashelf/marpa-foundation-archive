require 'spec_helper'

describe TalksController do

  describe "edit" do
    before do
      @program = Program.new
      @program.save
      @talk = Talk.new(:program=>@program)
      @talk.save
    end
    it "should set the instance vars" do
      get :edit, :id=>@talk.pid
      assigns(:talk).pid.should == @talk.pid
      assigns(:program).pid.should == @program.pid
      assigns(:recording_instantiation).should be_kind_of RecordingInstantiation
    end
    after do
      @program.delete
      @talk.delete
    end
  end

  describe "create" do
    before do
      @program = Program.new()
      @program.title='Investigation of the self'
      @program.save
    end
    it "Should assign the program and a new talk" do
      post :create, :program => @program.pid
      assigns(:program).title.should == 'Investigation of the self'
      assigns(:talk).persisted?.should be true
      assigns(:talk).program.pid.should == assigns(:program).pid
      response.should redirect_to(edit_talk_path(assigns(:talk)))
    end

    after do
      @program.delete
    end
  end

  describe "update" do
    before do
      @program = Program.new()
      @program.save
      @talk = Talk.new(:program=>@program)
      @talk.save
      @topic1 = Topic.new()
      @topic1.save
      @topic2 = Topic.new()
      @topic2.save
    end
    it "Should update the values" do
      put :update, :id=>@talk.pid, :talk=>{:topic_ids=>[@topic1.pid, @topic2.pid], :english_title=>"My Title", :date=>"2011-08-11", :duration=>'90 min', :subject=>'key1, key2' }
      updated = Talk.find(@talk.pid)
      updated.topics.map(&:pid).should include(@topic1.pid, @topic2.pid)
      updated.english_title.should == 'My Title'
      updated.date.should == '2011-08-11'
      updated.duration.should == '90 min'
      updated.subject.should == 'key1, key2'
      response.should redirect_to(edit_talk_path(@talk))
    end
    it "should redirect to associated program after saving if program is provided as a param" do
      put :update, :id=>@talk.pid, :talk=>{:topic_ids=>[@topic1.pid, @topic2.pid], :english_title=>"My Title"}, :program=>"programPID"
      response.should redirect_to(edit_program_path("programPID"))
    end



    after do
      @talk.delete
      @program.delete
      @topic1.delete
      @topic2.delete
    end

  end

  describe "add_song" do
    before do
      @talk = Talk.new()
      @talk.save
      @song = Song.new()
      @song.save
    end
    it "should add songs" do
      xhr :post, :add_song, :id=>@talk.pid, :song=>@song.pid
      Talk.find(@talk.pid).songs.map(&:pid).should include(@song.pid)
      response.should render_template '_song'
      
    end

    after do
      @talk.delete
      @song.delete
    end
  end

  describe "add talk_text" do
    before do
      @text = Text.new
      @text.save
      @talk = Talk.new()
      @talk.save
    end
    it "should create a talk_text" do
      xhr :post, :add_talk_text, :id=>@talk.pid, :text_id=>@text.pid
      assigns(:talk_text).talk.pid.should == @talk.pid
      response.should render_template 'talks/_nested_texts'
    end
    after do
      @text.delete
      @talk.delete
      assigns(:talk_text).delete
    end
  end

  describe "add_quotation" do
    before do
      @talk = Talk.new()
      @talk.save
      @quotation = Quotation.new()
      @quotation.save
    end
    it "should add quotations" do
      xhr :post, :add_quotation, :id=>@talk.pid, :quotation=>@quotation.pid
      Talk.find(@talk.pid).quotations.map(&:pid).should include(@quotation.pid)
      response.should render_template '_quotation'
      
    end

    after do
      @talk.delete
      @quotation.delete
    end
  end
end
