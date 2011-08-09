require 'spec_helper'

describe TextsController do

  before do
    @talk = Text.new()
    @talk.english_title='This modern world'
    @talk.save
  end

  describe "create action" do
    it "should assign the talk and a new text" do
      post :create, {:talk => @talk.pid}
      assigns(:talk).english_title.should == 'This modern world'
      assigns(:text).persisted?.should be true
      assigns(:text).talks.first.pid.should == assigns(:talk).pid
      response.should redirect_to(edit_text_path(assigns(:text), :talk=>assigns(:talk)))
    end
  end

  describe "edit action" do

    before do
      @user = User.new(:email=>"archivist@example.com")
      controller.stubs(:current_user).returns(@user)
      @text = Text.new()
      @text.english_title='This modern world'
      @text.apply_depositor_metadata(@user.login)
      @text.save
    end
    it "should assign the text" do
      get :edit, :id => @text.pid
      assigns(:text).pid.should == @text.pid
      response.should render_template 'edit'
    end
    after do
      @text.delete
    end
  end

  describe "update action" do
    before do
      @text = Text.new()
      @text.english_title='This modern world'
      @text.save
    end
    it "should assign the text" do
      put :update, :id => @text.pid, :text=>{:english_title=>"Far and away"}, :talk=>@talk.pid
      Topic.find(@text.pid).english_title.should == "Far and away"
      response.should redirect_to catalog_path(:id=>@talk)
    end
    after do
      @text.delete
    end
  end


  after do
    @talk.delete
  end
 
end
