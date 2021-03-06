require 'spec_helper'

describe TopicsController do
  before do
    @talk = Talk.new()
    @talk.english_title='This modern world'
    @talk.save
    @user = FactoryGirl.find_or_create(:archivist)
    sign_in @user
  end

  describe "create action" do
    it "should assign the talk and a new topic" do
      post :create, {:talk => @talk.pid}
      assigns(:talk).english_title.should == 'This modern world'
      assigns(:topic).persisted?.should be true
      assigns(:talk).topics.should include assigns(:topic)
      assigns(:topic).talks.map(&:pid).should include assigns(:talk).pid
      response.should redirect_to(edit_topic_path(assigns(:topic), :talk=>assigns(:talk)))
    end
  end

  describe "edit action" do

    before do
      @topic = Talk.new()
      @topic.english_title='This modern world'
      @topic.apply_depositor_metadata(@user.login)
      @topic.save
    end
    it "should assign the topic" do
      get :edit, :id => @topic.pid
      assigns(:topic).pid.should == @topic.pid
      response.should render_template 'edit'
    end
    after do
      @topic.delete
    end
  end

  describe "update action" do
    before do
      @topic = Talk.new()
      @topic.english_title='This modern world'
      @topic.save
    end
    it "should assign the topic" do
      put :update, :id => @topic.pid, :topic=>{:english_title=>"Far and away"}, :talk=>@talk.pid
      Topic.find(@topic.pid).english_title.should == "Far and away"
      response.should redirect_to edit_talk_path(@talk)
    end
    after do
      @topic.delete
    end
  end


  after do
    @talk.delete
  end

end
