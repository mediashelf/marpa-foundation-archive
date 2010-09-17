require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HydraAssetsHelper do
  include HydraAssetsHelper
  describe "delete_asset_link" do
    it "should generate a delete link and confirmation dialog" do
      generated_html = helper.delete_asset_link("__PID__", "whizbang")
      generated_html.should have_tag 'a.inline[href=#delete_dialog]',  "Delete this whizbang"
      generated_html.should have_tag 'div#delete_dialog' do
        with_tag "p", "Do you want to permanently delete this article from the repository?"
        with_tag "form[action=?]", url_for(:action => "destroy", :controller => "assets", :id => "__PID__", :method => "delete")  do
          with_tag "input[type=hidden][name=_method][value=delete]"
          with_tag "input[type=submit]"
        end
      end
    end
  end

  describe "get_person_from_role" do
    before(:all) do
      @single_person_doc = {"person_0_role_t" => ["creator"], "person_0_first_name_t" => "GIVEN NAME", "person_0_last_name_t" => "FAMILY NAME"}
      @multiple_persons_doc = {"person_0_role_t" => ["contributor","owner"], "person_0_first_name_t" => "CONTRIBUTOR GIVEN NAME", "person_0_last_name_t" => "CONTRIBUTOR FAMILY NAME",
                               "person_1_role_t" => ["creator"], "person_1_first_name_t" => "CREATOR GIVEN NAME", "person_1_last_name_t" => "CREATOR FAMILY NAME"}
     end
     it "should return the appropriate  when 1 is available" do
       person = get_person_from_role(@single_person_doc,"creator")
       person[:first].should == "GIVEN NAME" and
       person[:last].should == "FAMILY NAME"
     end
     it "should return the appririate person when there is multiple users" do
       person = get_person_from_role(@multiple_persons_doc,"creator")
       person[:first].should == "CREATOR GIVEN NAME" and
       person[:last].should == "CREATOR FAMILY NAME"
     end
     it "should return the appropriate person when they have multiple roles" do
       person = get_person_from_role(@multiple_persons_doc,"owner")
       person[:first].should == "CONTRIBUTOR GIVEN NAME" and 
       person[:last].should == "CONTRIBUTOR FAMILY NAME"
     end
     it "should return nil when there is no user for the given role" do
       get_person_from_role(@multiple_persons_doc,"bad_role").should be_nil
     end
  end

end
