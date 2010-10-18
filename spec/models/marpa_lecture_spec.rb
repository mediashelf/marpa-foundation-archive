require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"
require "marpa/csv_importer"

describe MarpaLecture do
  
  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @lecture = MarpaLecture.new
    @lecture.stubs(:create_date).returns("2008-07-02T05:09:42.015Z")
    @lecture.stubs(:modified_date).returns("2008-09-29T21:21:52.892Z")
  end
  
  it "Should be a kind of ActiveFedora::Base kind of FileAsset, and instance of VideoAsset" do
    @lecture.should be_kind_of(ActiveFedora::Base)
    @lecture.should be_kind_of(MarpaLecture)
  end
  
  it "should have the basic required metadata fields" do
    Marpa::CSVImporter.header_mappings.values.each do |mapping| 
      ds = @lecture.datastreams[mapping.first]
      field_pointer = mapping.last
      if ds.kind_of?(ActiveFedora::MetadataDatastream)
        if field_pointer.kind_of?(Array) then field_pointer = field_pointer.first end
        ds.fields.should have_key(field_pointer)
      else
        ds.class.terminology.should have_term(*field_pointer)
      end
    end
  end
  
end