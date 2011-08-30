require 'spec_helper'

describe ProgramsController do
  describe "as a logged in user" do 
    before do
      @user = User.new(:email=>"archivist@example.com")
      controller.stubs(:current_user).returns(@user)
    end
    describe "update" do
      before do
        @program = Program.new
        @program.apply_depositor_metadata(@user.email)
        @program.save
        @program_text = ProgramText.new(:program=>@program)
        @program_text.save
        @place = Place.new
        @place.save
      end
      it "should save the new values" do
        put :update, :id=>@program.pid, 
          :program=>{:creator =>'Thich Nhat Hanh', 
              :language=>{"tib"=>"1", "fre"=>"1", "chi"=>"0", "eng"=>"0", "ger"=>"1"}, :place_id => @place.pid, 
              :program_texts_attributes=>{"0"=>
                {"chapter"=>"chapt", "sections"=>"sects", "id"=>@program_text.pid, "pages"=>"pgs", "nature"=>"root"}}
          }
        object = Program.find(@program.pid)
        object.creator.should == 'Thich Nhat Hanh'
        object.language.should == ['tib', 'fre', 'ger']
        object.place.pid.should == @place.pid
        prog_text = ProgramText.find(@program_text.pid)
        prog_text.chapter.should == "chapt"
  ## TODO, update again and change the languages
      end 
      after do
        @place.delete
        @program_text.delete
        @program.delete
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

    describe "add program_text" do
      before do
        @text = Text.new
        @text.save
        @program = Program.new
        @program.save
      end
      it "should create a program_text" do
        xhr :post, :add_program_text, :id=>@program.pid, :text_id=>@text.pid
        assigns(:program_text).program.pid.should == @program.pid
        response.should render_template 'programs/_nested_texts'
      end
      after do
        @text.delete
        @program.delete
        assigns(:program_text).delete
      end
    end
  end
end
