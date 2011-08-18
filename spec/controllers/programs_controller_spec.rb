require 'spec_helper'

describe ProgramsController do
  describe "as a logged in user" do 
    before do
      @user = User.new(:email=>"archivist@example.com")
      controller.stubs(:current_user).returns(@user)
    end
    describe "update" do
      before do
        @place = Place.new
        @place.save
      end
      it "should save the new values" do
        put :update, :id=>'marpa:1', :program=>{:creator =>'Thich Nhat Hanh', :language=>{"tib"=>"1", "fre"=>"1", "chi"=>"0", "eng"=>"0", "ger"=>"1"}, :place_id => @place.pid}
        object = Program.find('marpa:1')
        object.creator.should == 'Thich Nhat Hanh'
        object.language.should == ['tib', 'fre', 'ger']
        object.place.pid.should == @place.pid
  ## TODO, update again and change the languages
      end 
      after do
        @place.delete
      end
    end 

    describe "create" do
      it "Should assign the course and a new talk" do
        post :create
        assigns(:program).persisted?.should be true
        response.should redirect_to(edit_program_path(assigns(:program)))
        ### TODO, delete this program
      end
    end

    describe "edit" do
      it "should assign the course" do
        get :edit, :id=>'marpa:1'
        assigns(:program).should_not be_nil
        response.should render_template 'edit'
      end
    end
  end
end
