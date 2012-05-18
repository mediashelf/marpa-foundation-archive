require 'spec_helper'

describe SongsController do
  before do
    @talk = Talk.new()
    @talk.english_title='This modern world'
    @talk.save
    @user = FactoryGirl.find_or_create(:archivist)
    sign_in @user
  end

  describe "create action" do
    it "should crete a new song" do
      post :create, {:talk => @talk.pid}
      assigns(:song).persisted?.should be true
      response.should redirect_to(edit_song_path(assigns(:song), :talk=>@talk.pid))
    end
  end

  describe "edit action" do

    before do
      @song = Song.new()
      @song.english_title='Rolling in the deep'
      @song.apply_depositor_metadata(@user.login)
      @song.save
    end
    it "should assign the song" do
      get :edit, :id => @song.pid
      assigns(:song).pid.should == @song.pid
      response.should render_template 'edit'
    end
    after do
      @song.delete
    end
  end

  describe "update action" do
    before do
      @song = Song.new()
      @song.english_title='Trying your luck'
      @song.save
    end
    it "should assign the song" do
      put :update, :id => @song.pid, :song=>{:english_title=>"Far and away"}, :talk=>@talk.pid
      Song.find(@song.pid).english_title.should == "Far and away"
      response.should redirect_to edit_song_path(@song)
    end
    after do
      @song.delete
    end
  end


  after do
    @talk.delete
  end

end
