require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hydra::ModelMethods do
  
  describe "apply_depositor_metadata" do
    it "should set the depositor metadata field and assign edit permissions to the given depositor_id" do
      prop_ds = mock("properties ds")
      rights_ds = mock("rights ds")
      prop_ds.expects(:respond_to?).with(:depositor_values).returns(true)
      prop_ds.expects(:depositor_values=).with("foouser")
      rights_ds.expects(:update_indexed_attributes).with([:edit_access, :person]=>"foouser")

      helper.stubs(:datastreams_in_memory).returns({"rightsMetadata"=>rights_ds,"properties"=>prop_ds})
      helper.stubs(:apply_ldap_values)
      helper.apply_depositor_metadata("foouser")
    end
  end

  describe "set_collection_type" do
    it "should set the collection metadata field" do
      prop_ds = mock("properties ds")
      prop_ds.expects(:respond_to?).with(:collection_values).returns(true)
      prop_ds.expects(:collection_values=).with("hydrangea_article")

      helper.stubs(:datastreams_in_memory).returns({"properties"=>prop_ds})
      helper.set_collection_type("hydrangea_article")
    end
  end

  describe "#destroyable_child_assets" do
    it "should return an array of file assets available for deletion" do
      ha = HydrangeaArticle.load_instance("hydrangea:fixture_mods_article1")
      deletable_assets = ha.destroyable_child_assets
      deletable_assets.should be_a_kind_of Array
      deletable_assets.length.should == 1
      deletable_assets[0].pid.should == "hydrangea:fixture_uploaded_svg1"
    end
    it "should return an empty array if there are now file assets" do
      ha = HydrangeaArticle.load_instance("hydrangea:fixture_mods_article2")
      deletable_assets = ha.destroyable_child_assets
      deletable_assets.should be_a_kind_of Array
      deletable_assets.should be_empty
    end
  end

  describe "#destroy_child_assets" do
    it "should destroy any child assets and return an array listing the child assets" do
      ha = HydrangeaArticle.load_instance("hydrangea:fixture_mods_article1")
      file_asset = mock("file object")
      file_asset.expects(:pid).returns("hydrangea:fixture_uploaded_svg1")
      file_asset.expects(:delete).returns(true)
      ha.stubs(:destroyable_child_assets).returns([file_asset])
      ha.destroy_child_assets.should == ["hydrangea:fixture_uploaded_svg1"]
    end
    it "should do nothing and return an empty array for an object with no child assets" do
      ha = HydrangeaArticle.load_instance("hydrangea:fixture_mods_article2")
      ha.destroy_child_assets.should == []
    end
  end


end
