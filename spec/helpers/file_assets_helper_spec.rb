require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hydra::FileAssetsHelper do
  describe "create_and_save_file_asset_from_params" do
    it "should create the file asset, add posted blob to it and save the file asset" do
      helper.expects(:params).returns( { :Filedata => "" } )      
      mock_fa = mock("file asset")
      mock_fa.expects(:save)
      helper.expects(:create_asset_from_params).returns(mock_fa)
      helper.expects(:add_posted_blob_to_asset)
      helper.create_and_save_file_asset_from_params
    end
  end
  
  describe "create_asset_from_params" do
    it "should create a new file asset and set the label from params[:Filename]" do
      helper.expects(:params).returns( { :Filename => "Test Filename" } )
      result = helper.create_asset_from_params
      result.should be_kind_of FileAsset
      result.label.should == "Test Filename"
    end
    it "should choose model by filename" do
      pending "this is currently disabled"
      helper.expects(:choose_model_by_filename)
      helper.create_asset_from_params
    end
  end
  
  describe "choose_model_by_filename" do
    it "should attempt to guess at type and set model accordingly" do
      helper.choose_model_by_filename("meow.mp3").should == AudioAsset
      helper.choose_model_by_filename("meow.wav").should == AudioAsset
      helper.choose_model_by_filename("meow.aiff").should == AudioAsset
      
      helper.choose_model_by_filename("meow.mov").should == VideoAsset
      helper.choose_model_by_filename("meow.flv").should == VideoAsset
      helper.choose_model_by_filename("meow.m4v").should == VideoAsset
      
      helper.choose_model_by_filename("meow.jpg").should == ImageAsset
      helper.choose_model_by_filename("meow.jpeg").should == ImageAsset
      helper.choose_model_by_filename("meow.png").should == ImageAsset
      helper.choose_model_by_filename("meow.gif").should == ImageAsset
    end
  end
end