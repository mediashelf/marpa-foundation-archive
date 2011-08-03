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

end
