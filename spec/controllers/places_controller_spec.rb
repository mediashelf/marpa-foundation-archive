require 'spec_helper'

describe PlacesController do
  describe "adding a new place" do
    it "Should have a create form " do
      get :create
      response.should be_success
      assigns(:place).should_not be_nil
    end 
  end

end
