require 'spec_helper'

describe TranslatorsController do
  describe "adding a new translator" do
    before do
      @program = Program.new()
      @program.save
    end
    it "Should have a create form " do
      post :create, :program=>@program
      response.should redirect_to(edit_program_path(:id=>@program))
      assigns(:translator).should_not be_nil
    end 

    after do
      @program.delete
    end
  end

end
