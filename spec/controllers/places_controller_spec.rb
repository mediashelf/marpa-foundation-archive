require 'spec_helper'

describe PlacesController do
  describe "adding a new place" do
    before do
      @program = Program.new()
      @program.save
    end
    it "Should have a create form " do
      post :create, :program=>@program
      response.should redirect_to(edit_program_path(:id=>@program))
      assigns(:place).should_not be_nil
    end 

    after do
      @program.delete
    end
  end

end
