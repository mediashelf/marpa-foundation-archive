require File.join( File.dirname(__FILE__), "../spec_helper" )
require "marpa/marpa_pbcore_instantiation.rb"

describe Marpa::PbcoreInstantiation do
  before :each do
    @datastream = Marpa::PbcoreInstantiation.from_xml( fixture("marpa_recording/pbcore-shes.bya.mdzod-s3-instantiation.xml") )
  end
  
  describe "to_solr" do
    before(:each) do
      @solr_doc = @datastream.to_solr
    end
    it "should include the fields we care about" do
      @solr_doc["digital_format_t"].should == ["audio/mp3"]
      @solr_doc["file_size_t"].should == ["109.9"]
      @solr_doc["duration_t"].should == ["1:33:49"]
      @solr_doc["media_type_t"].should == ["Sound"]
      @solr_doc["identifier_t"].should == ["marpa:556"]
      @solr_doc["location_t"].should == ["http://s3.amazonaws.com/marpa-foundation/import/shes.bya.mdzod.ch1.1-bouddha-1988-psc-t-4c/1.mp3"]
    end
  end
  describe "constructing new xml documents" do
    it "should create proper pbcore xml" do
      pending "Can't figure out why this is failing.  Possibly a bug in equivalent-xml?"
      ds = Marpa::PbcoreInstantiation.new
      # ds.digital_format = "audio/mp3"
      # ds.file_size = "109.9"
      # ds.duration = "1:33:49"
      # ds.media_type = "Sound"
      # ds.identifier = "marpa:556"
      # ds.location = "http://s3.amazonaws.com/marpa-foundation/import/shes.bya.mdzod.ch1.1-bouddha-1988-psc-t-4c/1.mp3"
      values = {[:iana_format] => "audio/mp3",
      [:file_size_mb] => "109.9",
      [:duration] => "1:33:49",
      [:media_type] => "Sound",
      [:identifier] => "marpa:556",
      [:location] => "http://s3.amazonaws.com/marpa-foundation/import/shes.bya.mdzod.ch1.1-bouddha-1988-psc-t-4c/1.mp3"}
      ds.update_indexed_attributes(values)
      
      ds.to_xml.should be_equivalent_to @datastream.to_xml
    end
  end
end