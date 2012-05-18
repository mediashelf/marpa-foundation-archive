require 'spec_helper'

describe PlacesController do
  describe "#new" do
    it "Should have form" do
      get :new, :program=>@program
      response.should be_success
    end
  end
  describe "creating a new place" do
    before do
      @program = Program.new()
      @program.save
      @count = Place.find(:all, :rows=>1000).size
      @user = FactoryGirl.find_or_create(:archivist)
      sign_in @user
    end
    it "Should have a create form " do
      post :create, :program=>@program
      response.should redirect_to(edit_program_path(:id=>@program))
      assigns(:place).should_not be_nil
      Place.find(:all, :rows=>1000).size.should == @count + 1
    end 

    after do
      @program.delete
    end
  end

end
