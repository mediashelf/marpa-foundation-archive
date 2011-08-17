require 'spec_helper'

describe ProgramsController do
  describe "update" do
    it "should save the new values" do
# {"commit"=>"Save changes", "content_type"=>"marpa_course", "language"=>{"tib"=>"0", "fre"=>"0", "chi"=>"0", "eng"=>"0", "ger"=>"0"}, "field_selectors"=>{"descMetadata"=>{"start_date"=>["start_date"], "title"=>["title"], "creator"=>["creator"], "end_date"=>["end_date"]}}, "authenticity_token"=>"luRiQVgKEsD+Rm0fB9+eGvcrhBojZawERtqnDb3x6t8=", "utf8"=>"✓", "contributor"=>"marpa:210", "id"=>"marpa:514", "place"=>"marpa:56", "asset"=>{"descMetadata"=>{"start_date"=>{"0"=>""}, "title"=>{"0"=>"General Teachings on Buddha nature - Gyu Lama hey"}, "creator"=>{"0"=>"Jean Claude X"}, "end_date"=>{"0"=>""}}}}
      put :update, :id=>'marpa:1', :content_type=>"marpa_course", :asset=>{:descMetadata => {:creator =>{"0" =>'Thich Nhat Hanh'}}}, "field_selectors"=>{"descMetadata"=>{"start_date"=>["start_date"], "title"=>["title"], "creator"=>["creator"], "end_date"=>["end_date"]}}, "language"=>{"tib"=>"1", "fre"=>"1", "chi"=>"0", "eng"=>"0", "ger"=>"1"}
      object = Program.find('marpa:1')
      object.creator.should == 'Thich Nhat Hanh'
      object.language.should == ['tib', 'fre', 'ger']

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
      response.should render('_edit_description')
    end
  end

end
