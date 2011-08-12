require 'spec_helper'

describe AssetsController do
  describe "updating a course" do
    before do
      sign_in :user , User.new
      loader = Hydra::FixtureLoader.new('spec/fixtures')
      loader.reload('marpa:1')
    end
    it "should save the new values" do
# {"commit"=>"Save changes", "content_type"=>"marpa_course", "language"=>{"tib"=>"0", "fre"=>"0", "chi"=>"0", "eng"=>"0", "ger"=>"0"}, "field_selectors"=>{"descMetadata"=>{"start_date"=>["start_date"], "title"=>["title"], "creator"=>["creator"], "end_date"=>["end_date"]}}, "authenticity_token"=>"luRiQVgKEsD+Rm0fB9+eGvcrhBojZawERtqnDb3x6t8=", "utf8"=>"✓", "contributor"=>"marpa:210", "id"=>"marpa:514", "place"=>"marpa:56", "asset"=>{"descMetadata"=>{"start_date"=>{"0"=>""}, "title"=>{"0"=>"General Teachings on Buddha nature - Gyu Lama hey"}, "creator"=>{"0"=>"Jean Claude X"}, "end_date"=>{"0"=>""}}}}
      put :update, :id=>'marpa:1', :content_type=>"marpa_course", :asset=>{:descMetadata => {:creator =>{"0" =>'Thich Nhat Hanh'}}}, "field_selectors"=>{"descMetadata"=>{"start_date"=>["start_date"], "title"=>["title"], "creator"=>["creator"], "end_date"=>["end_date"]}}
      object = MarpaCourse.find('marpa:1')
      object.creator.should == 'Thich Nhat Hanh'

    end 
  end 

end
