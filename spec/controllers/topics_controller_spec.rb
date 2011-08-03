require 'spec_helper'

describe TopicsController do
  describe "new action" do
    before do
      @talk = Talk.new()
      @talk.english_title='This modern world'
      @talk.save
    end
    it "should assign the talk and a new topic" do
      get :new, {:talk => @talk.pid}
      assigns(:talk).english_title.should == 'This modern world'
      assigns(:topic).persisted?.should be false
    end

    after do
      @talk.delete
    end
  end

end
