require 'spec_helper'

describe TalksController do

  describe "create" do
    before do
      @course = MarpaCourse.new()
      @course.title='Investigation of the self'
      @course.save
    end
    it "Should assign the course and a new talk" do
      post :create, {:course => @course.pid}
      assigns(:course).title.should == 'Investigation of the self'
      assigns(:talk).persisted?.should be true
      assigns(:talk).courses.first.pid.should == assigns(:course).pid
      response.should redirect_to(edit_talk_path(assigns(:talk)))
    end

    after do
      @course.delete
    end
  end

  describe "update" do
    before do
      @talk = Talk.new()
      @talk.save
      @topic1 = Topic.new()
      @topic1.save
      @topic2 = Topic.new()
      @topic2.save
    end
    it "Should update the values" do
      put :update, :id=>@talk.pid, :talk=>{:topic_ids=>[@topic1.pid, @topic2.pid]}
      Talk.find(@talk.pid).topics.map(&:pid).should include(@topic1.pid, @topic2.pid)
    end



    after do
      @talk.delete
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

  describe "add_text" do
    before do
      @talk = Talk.new()
      @talk.save
      @text = Text.new()
      @text.save
    end
    it "should add texts" do
      xhr :post, :add_text, :id=>@talk.pid, :text=>@text.pid
      Talk.find(@talk.pid).texts.map(&:pid).should include(@text.pid)
      response.should render_template '_text'
      
    end

    after do
      @talk.delete
      @text.delete
    end
  end

end
