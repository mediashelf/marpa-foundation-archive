require File.join( File.dirname(__FILE__), "../spec_helper" )

describe Marpa::Datastreams::Location do
  before :each do
    @datastream = Marpa::Datastreams::Location.from_xml( fixture("marpa_location/place.xml") )
  end
  describe "to_solr" do
    before(:each) do
      @solr_doc = @datastream.to_solr
    end
    it "should not need any indexing" do
      @solr_doc.should == {'name_t'=>['CodeSpace'], 'description_t'=>['A good place to find coders']}
    end
  end
  describe "the terminology" do
    before(:each) do
    end
    it "should have stuff" do
      @datastream.term_values(:latitude).should == ['44.949955']
      @datastream.term_values(:longitude).should == ['-93.285441']
      @datastream.term_values(:name).should == ["CodeSpace"]
      @datastream.term_values(:description).should == ["A good place to find coders"]
    end
  end
end

