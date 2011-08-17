require 'spec_helper'

describe PlacesController do
  describe "adding a new place" do
    before do
      @course = Program.new()
      @course.save
    end
    it "Should have a create form " do
      post :create, :course=>@course
      response.should redirect_to(catalog_path(:id=>@course))
      assigns(:place).should_not be_nil
    end 

    after do
      @course.delete
    end
  end

end
